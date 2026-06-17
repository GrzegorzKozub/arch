#!/usr/bin/env bash
# Pre-install AUR package scanner. Usage: aur.sh <pkg> [pkg...] && paru -S --aur --noconfirm <pkg> [pkg...]
set -eo pipefail

RED='\033[0;31m'; YEL='\033[0;33m'; GRN='\033[0;32m'; RST='\033[0m'

VULN_LIST_URL="https://md.archlinux.org/s/SxbqukK6IA/download"

BAD_ACCOUNTS=(krisztinavarga franziskaweber tobiaswesterburg ellenmyklebust custodiatovar veramagalhaes)
BAD_NPM_PKGS=(atomic-lockfile js-digest lockfile-js nextfile-js)
EXT_PKG_MGR_RE='(npm|bun|pnpm|yarn|cargo|pip[3x]?|gem)\s+(install|add|i\b)'
BAD_NPM_RE="$(IFS='|'; echo "${BAD_NPM_PKGS[*]}")"
OBF_RE='\$'"'"'\\\\(x[0-9a-fA-F]{2}|[0-7]{3})'

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <package> [package...]" >&2
    exit 1
fi

# Fetch compromised package list once
echo "Fetching live compromised package list..."
VULN_PKGS=$(curl -fsSL --max-time 15 "$VULN_LIST_URL" 2>/dev/null \
    | sed 's/^```.*//;s/^`.*//' \
    | grep -E '^[a-zA-Z0-9_+@.-]+$' || true)
if [[ -z "$VULN_PKGS" ]]; then
    echo -e "${YEL}[WARN]${RST} Could not fetch live compromised list — skipping that check"
fi

FAILED=0

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

for PKG in "$@"; do
    echo
    echo -e "── ${PKG} ──────────────────────────────────────"
    PKG_FAILED=0

    # 1. Check against compromised list
    if [[ -n "$VULN_PKGS" ]] && echo "$VULN_PKGS" | grep -qxF "$PKG"; then
        echo -e "${RED}[FAIL]${RST} $PKG is on the live compromised package list"
        PKG_FAILED=1
    fi

    # 2. Clone AUR repo (last 5 commits)
    PKG_DIR="$TMP/$PKG"
    if ! git clone --depth=5 --quiet "https://aur.archlinux.org/${PKG}.git" "$PKG_DIR" 2>/dev/null; then
        echo -e "${YEL}[WARN]${RST} Could not clone AUR repo for $PKG — package may not exist"
        FAILED=1
        continue
    fi

    # 3. Check recent committers against known bad accounts
    while IFS= read -r author; do
        for BAD in "${BAD_ACCOUNTS[@]}"; do
            if [[ "${author,,}" == *"${BAD,,}"* ]]; then
                echo -e "${RED}[FAIL]${RST} Recent committer matches known malicious account: $author"
                PKG_FAILED=1
            fi
        done
    done < <(git -C "$PKG_DIR" log --format='%an <%ae>' 2>/dev/null)

    # 4. Scan PKGBUILD and *.install for malicious patterns
    while IFS= read -r -d '' FILE; do
        # Known bad npm packages
        if grep -qE "$BAD_NPM_RE" "$FILE" 2>/dev/null; then
            echo -e "${RED}[FAIL]${RST} Known malicious npm package referenced in $(basename "$FILE"):"
            grep -nE "$BAD_NPM_RE" "$FILE"
            PKG_FAILED=1
        fi
        # External package manager calls (never legitimate in AUR hooks)
        if grep -qE "$EXT_PKG_MGR_RE" "$FILE" 2>/dev/null; then
            echo -e "${RED}[FAIL]${RST} External package manager call in $(basename "$FILE"):"
            grep -nE "$EXT_PKG_MGR_RE" "$FILE"
            PKG_FAILED=1
        fi
        # Shell obfuscation
        if grep -qE "$OBF_RE" "$FILE" 2>/dev/null; then
            echo -e "${YEL}[WARN]${RST} Shell escape obfuscation in $(basename "$FILE"):"
            grep -nE "$OBF_RE" "$FILE"
            PKG_FAILED=1
        fi
    done < <(find "$PKG_DIR" -maxdepth 1 \( -name "PKGBUILD" -o -name "*.install" \) -print0 2>/dev/null)

    # 5. Show recent git log for manual awareness
    echo "Recent commits:"
    git -C "$PKG_DIR" log --oneline --format='  %h %as %an — %s' 2>/dev/null | head -5

    if [[ "$PKG_FAILED" -eq 0 ]]; then
        echo -e "${GRN}[OK]${RST} $PKG looks clean"
    else
        echo -e "${RED}[BLOCKED]${RST} $PKG — install aborted"
        FAILED=1
    fi
done

echo
if [[ "$FAILED" -ne 0 ]]; then
    echo -e "${RED}Scan failed — not proceeding with install.${RST}"
    exit 1
fi
echo -e "${GRN}All packages passed — proceeding with install.${RST}"
