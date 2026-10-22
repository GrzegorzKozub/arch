# Migrating dev tools from pacman/AUR to mise

Plan to move the dev tooling currently installed by `apps.sh` and `claude.sh` to mise. Nothing here has been applied yet.

## Scope

| Tool | Installed today | Package | mise tool | Installed by |
| --- | --- | --- | --- | --- |
| golangci-lint | AUR | `golangci-lint-bin` | `golangci-lint` (aqua) | `apps.sh` |
| shellcheck | AUR | `shellcheck-bin` | `shellcheck` (aqua) | `apps.sh` |
| shfmt | repo | `shfmt` | `shfmt` (aqua) | `apps.sh` |
| stylua | repo | `stylua` | `stylua` (aqua) | `apps.sh` |
| lua-language-server | repo | `lua-language-server` | `lua-language-server` (aqua) | `claude.sh` |
| tree-sitter | repo | `tree-sitter-cli` | `tree-sitter` (aqua) | `apps.sh` |
| prettier | repo | `prettier` | `npm:prettier` | `apps.sh` |

`uv` is planned separately in [Migrating uv](#migrating-uv) below.

## Reverse dependency check

Checked with `pacman -Qi <pkg>` on drifter:

- None of the seven packages has anything under **Required By** or **Optional For**.
- All are explicitly installed, so removing one will not orphan or break another package.
- `shellcheck-bin` provides `shellcheck`. Nothing requires that provide, but removing the package removes it.
- `tree-sitter-cli` is a standalone binary. The `tree-sitter` library package is not installed and is not touched.

Re-run this check on player and worker before removing anything there, since their package sets can differ:

```bash
for p in golangci-lint-bin shellcheck-bin shfmt stylua lua-language-server tree-sitter-cli prettier; do
  pacman -Qi "$p" | grep -E '^(Name|Required By|Optional For)'
done
```

## Things to check before removing the packages

- **Neovim uses these tools.** `conform.lua` calls `prettier`, `stylua` and `shfmt`, `lint.lua` calls `golangci-lint`, and `lsp.lua` starts `lua-language-server`. Neovim must find them on `PATH` when started from the GNOME launcher or a terminal.
- **Mason overlap.** `mason-tool-installer.lua` also lists `lua-language-server` and `golangci-lint`. Neovim may already be using the Mason copies rather than the pacman ones. Check `:checkhealth mason` and `:echo exepath('golangci-lint')`. If Mason supplies them, the pacman copies are redundant, and the choice is Mason or mise, not both.
- **Claude Code LSP.** `claude.sh` installs `lua-language-server` for Claude Code. Claude Code must see the mise copy, so it has to start from a shell where mise is activated.
- **Install scripts.** `apps.sh`, `claude.sh` and `README.md` list these packages. A fresh install must still end up with the tools, so mise has to be installed and configured before the tools are needed.
- **Repo lint tooling.** `CLAUDE.md` documents `shellcheck <script>.sh` and `npx prettier --check .`. The repo's `package.json` already pins ESLint and Prettier, so decide whether the global `prettier` is still needed at all.
- **PATH outside shells.** mise tools are only on `PATH` where mise is activated. Anything started from a systemd unit, cron or a desktop launcher will not find them unless shims are on `PATH`. None of these seven is run from a unit, but Neovim and Claude Code can be launched from the desktop.

## Plan

### 1. Pin versions and add the tools

Add to `~/code/dot` (stowed to `~/.config/mise/config.toml`), next to the existing go, node and bun entries:

```toml
[tools]
golangci-lint = "latest"
lua-language-server = "latest"
shellcheck = "latest"
shfmt = "latest"
stylua = "latest"
tree-sitter = "latest"
"npm:prettier" = "latest"
```

Then install them while the pacman copies are still present:

```bash
mise install
mise ls
```

`golangci-lint` is the one worth pinning to a major (for example `"2"`), because a new major changes its config format. Everything else is fine on `latest`, in line with the existing entries.

### 2. Verify that mise's copy wins

```bash
mise which golangci-lint shellcheck shfmt stylua lua-language-server tree-sitter prettier
mise x -- golangci-lint --version
which -a stylua   # mise's path should come before /usr/bin
```

Open Neovim and check formatting (`:ConformInfo`), linting on a Go file, the Lua LSP (`:LspInfo`), and treesitter parser builds (`:TSInstall`).

### 3. Update the install scripts

- `apps.sh`: remove `stylua`, `prettier`, `shfmt` and `tree-sitter-cli` from the pacman block, and `golangci-lint-bin` and `shellcheck-bin` from the `yay` block. Keep `mise` and `usage`.
- `claude.sh`: remove `sudo pacman -S --noconfirm lua-language-server`.
- `migrate.sh` already runs `~/code/dot/reset.sh mise`, which should install the tools from `config.toml` on each machine.
- `README.md`: update any package lists that mention these tools.

### 4. Remove the pacman packages

Only after steps 1 to 3 work:

```bash
sudo pacman -Rns golangci-lint-bin shellcheck-bin shfmt stylua lua-language-server tree-sitter-cli prettier
```

Use `-Rns` and read the list pacman prints. It should show only these packages and their unused dependencies.

### 5. Repeat on player and worker

Run `migrate.sh` on each machine, then the same checks and removal. Do the pacman removal last on each.

## Rollback

- Per tool: `sudo pacman -S <pkg>` (or `yay -S` for the two AUR packages) and remove the line from `config.toml`.
- Order matters: install the mise copy first and remove the pacman copy last. That way there is never a moment without the tool.

## Downsides to accept

- No man pages or shell completions from pacman for these tools. `shellcheck` and `shfmt` have man pages, so decide whether that matters.
- `latest` plus `prune_after = "0s"` means `mise upgrade` can pull a breaking release with no way back unless you pin.
- Binaries come from upstream releases (aqua, npm), not from Arch or AUR maintainers.
- `mise activate` must run in every shell and session that launches these tools.
- The `tree-sitter` binary from aqua may need a matching glibc. It is a prebuilt release, so check `tree-sitter --version` on a fresh install.

## Migrating uv

Only the `uv` binary moves to mise. The tools installed with `uv tool install` stay managed by uv, not by mise's `pipx:` backend, so nothing about how they are installed, upgraded or reset changes.

### What uses uv today

Found by searching `~/code/dot` and `~/code/arch`:

| What | Where | Machines |
| --- | --- | --- |
| `lastversion`, `linecast`, `tiddl` | `dot/install.sh`, `dot/reset.sh python` | all |
| `yt-dlp[secretstorage]` with `--with yt-dlp-ejs` | `dot/install.sh`, `dot/reset.sh python` | all |
| `awscli-local`, `cfn-lint` | `dot/aws.sh`, `dot/reset.sh python` | worker only |
| `basedpyright` | `dot/claude.sh`, `dot/reset.sh python` | machines with `claude` |
| `uv tool upgrade --all`, `uv cache prune` | `dot/update.sh` | all |
| `uvx` for MCP servers in Claude plugins | plugin configs, not in either repo | wherever the plugins are installed |

The tools live in `$XDG_DATA_HOME/uv/tools/`, with launchers in `~/.local/bin`. Both are independent of where the `uv` binary comes from.

### Check before moving

- **Reverse dependencies:** `pacman -Qi uv` shows nothing under Required By or Optional For on drifter. Re-run it on player and worker.
- **Python source:** uv currently uses the system Python 3.14 from pacman (`uv python list --only-installed`). Moving uv does not change that. Keep `python`, `python-pip`, `python-pynvim` and `python-requests` in pacman, because `fetch.py` and nvim need them.
- **`uvx` and Claude plugins:** MCPs from plugins call `uvx` by name. Claude must be started from a shell where mise is active, or from a launcher that has `~/.local/share/mise/shims` on `PATH`. Test with `claude` from a shell, and from the GNOME launcher if you use it.
- **Order of `PATH`:** mise paths already come before `/usr/bin`, so the mise `uv` wins. Confirm with `which -a uv uvx`.
- **`uv self update`:** it does not work for pacman installs and is not needed for a mise install either, since mise handles updates.

### Plan

1. Add uv to `~/code/dot` (`mise/config.toml`):

   ```toml
   uv = "latest"
   ```

2. Install it next to the pacman copy and check which one runs:

   ```bash
   mise install uv
   which -a uv uvx
   uv --version
   uv tool list    # existing tools must still be listed
   ```

3. Check that the tools still work and still upgrade with the new binary:

   ```bash
   yt-dlp --version
   basedpyright --version
   uv tool upgrade --all
   ```

   They should not need reinstalling, because uv does not change interpreter: it still finds the system Python.

4. Start Claude Code from a shell and confirm the plugin MCPs that use `uvx` still start (`/mcp`).

5. Update the install scripts:
   - `arch/apps.sh`: remove `uv` from the pacman `# dev` block. Keep `python`, `python-pip`, `python-pynvim` and `python-requests`.
   - `dot/install.sh`: make sure `mise install` runs before the `uv tool install` lines, since `uv` now comes from mise. Today it assumes `uv` is already on the machine.
   - `dot/reset.sh python`: add `mise install uv` at the top if mise might not have installed it yet. The rest (wiping `$XDG_DATA_HOME/uv/`, cleaning dangling symlinks, reinstalling tools) stays as it is.
   - `dot/update.sh`: `uv tool upgrade --all` and `uv cache prune` stay. Run `mise upgrade` before them so the uv binary itself is current.
   - `dot/CLAUDE.md`: update the "python (uv)" note in the `install.sh` row.

6. Remove the pacman package, once steps 2 to 4 pass on a machine:

   ```bash
   sudo pacman -Rns uv
   ```

7. Repeat on player and worker. On worker, also check `awscli-local` and `cfn-lint` (`awslocal --version`, `cfn-lint --version`).

### Rollback

`sudo pacman -S uv` and remove the line from `config.toml`. The installed tools and their launchers are not affected either way.

### Downsides

- The AWS tools and the yt-dlp set are not described anywhere in mise, so `config.toml` does not tell you what is installed. That list is still in `dot`'s scripts.
- A broken `latest` uv release would land on your next `mise upgrade`. Pin it (for example `uv = "0.13"`) if that worries you.
- `uvx` outside a mise-activated shell (a systemd unit, cron, or a launcher without the shims directory on `PATH`) will not find uv.

## Migrating the AWS CLI

`arch/aws.sh` (called from `work.sh`, so drifter and worker only) installs `aws-cli-v2` from pacman and `aws-sam-cli-bin` from the AUR, then runs `~/code/dot/aws.sh` and `~/code/keys/aws.sh`. `dot/aws.sh` installs `awscli-local` and `cfn-lint` with `uv tool install`.

### Scope

| Tool | Installed today | mise tool | Result |
| --- | --- | --- | --- |
| AWS CLI v2 | `aws-cli-v2` (pacman) | `aws-cli` (aqua) | moves |
| SAM CLI | `aws-sam-cli-bin` (AUR) | `aws-sam` (aqua) | moves |
| `awscli-local`, `cfn-lint` | `uv tool install` in `dot/aws.sh` | not in the registry | stays on uv |

`aws-sam` also exists as `pypi:aws-sam-cli`, which would go through uv. Use the aqua entry, which is a prebuilt binary.

### Check before moving

- **Not installed everywhere:** `aws` is not installed on this machine, so nothing needs removing here. Check `pacman -Qi aws-cli-v2 aws-sam-cli-bin` on each machine and re-run the reverse dependency check before removal.
- **Claude sandbox:** `README.md` says `aws` is in `excludedCommands` so it can escape the sandbox. Check that the exclusion matches the mise binary and not only `/usr/bin/aws`.
- **Release delay:** mise hides recent releases because of `minimum_release_age`, so you will lag the newest aws-cli by a few days. This is already set up in your mise config, and I expect you want it to stay.
- **`PATH`:** mise tools are only on `PATH` where mise is active. A systemd unit, cron job or desktop launcher that calls `aws` needs the shims directory on its `PATH`.
- **Credentials:** `~/.aws` and `~/code/keys/aws.sh` do not depend on where the binary lives.

### Plan

1. Add to `~/code/dot` (`mise/config.toml`). Alternatively, put them in a `conf.d` file used only on drifter and worker, since other machines do not need them:

   ```toml
   aws-cli = "latest"
   aws-sam = "latest"
   ```

2. Install them next to the pacman copies:

   ```bash
   mise install
   which -a aws sam
   aws --version
   sam --version
   ```

3. Run an `aws` command and a `sam` command against a real profile. Do this from a Claude Code session too, if you use it with `aws`.

4. Update `arch/aws.sh`: remove the pacman and `yay` blocks. Keep the `packages.sh`, `~/code/dot/aws.sh` and `~/code/keys/aws.sh` steps. `mise install` has to run before `~/code/dot/aws.sh` if that script ever calls `aws`.

5. Remove the packages, once step 3 passes:

   ```bash
   sudo pacman -Rns aws-cli-v2 aws-sam-cli-bin
   ```

6. Repeat on the other machine that runs `work.sh`.

### Rollback

`sudo pacman -S aws-cli-v2` and `yay -S aws-sam-cli-bin`, then remove the lines from `config.toml`. `~/.aws` is not touched.

### Left as is

`awscli-local` and `cfn-lint` stay as `uv tool install` in `dot/aws.sh` and `dot/reset.sh python` (worker only). They do not need the mise `aws`.

## Zsh completions

Moving a tool to mise removes the completion file its pacman package put in `/usr/share/zsh/site-functions`. The zsh config in `~/code/dot/zsh/zsh` needs a replacement for each tool that can generate one.

### How completions are wired today

- Each tool has a plugin at `dot/zsh/zsh/<tool>/<tool>.plugin.zsh`, loaded from `.zshrc` with `zi ice lucid nocompletions wait'0' && zi light "$ZDOTDIR"/<tool>`, often inside an `if (( $+commands[<tool>] ))` guard.
- Plugins like `linecast`, `rustup` and `mise` define `_my-compdef-<tool>`, which `eval`s the tool's own completion output on first tab and then calls the generated function. They finish with `compdef _my-compdef-<tool> <tool>`.
- `compinit/compinit.plugin.zsh` already runs `bashcompinit`, which `aws` needs.
- `.zshrc` has `fpath=(~/code/arch $fpath[@])`, so completion files can also be dropped into `arch`.

### What each planned tool can provide

| Tool | Completion today | Can mise's copy generate one? | Action |
| --- | --- | --- | --- |
| `golangci-lint` | `_golangci-lint` from `golangci-lint-bin` | yes, `golangci-lint completion zsh` | add plugin |
| `tree-sitter` | `_tree-sitter` from `tree-sitter-cli` | yes, `tree-sitter complete --shell zsh` | add plugin |
| `uv` | `_uv` from `uv` | yes, `uv generate-shell-completion zsh` | add plugin |
| `uvx` | none (the package only ships `_uv`) | yes, `uvx --generate-shell-completion zsh` | add to the `uv` plugin |
| `aws` | `aws` plugin with `complete -C /usr/bin/aws_completer aws` | yes, the aqua package includes `aws_completer` | fix the hard-coded path |
| `shellcheck` | `_shellcheck` from `zsh-completions` | no generator, but not needed | nothing: `zsh-completions` stays in pacman |
| `shfmt`, `stylua`, `lua-language-server`, `prettier` | none | no | nothing to do |
| `sam` | none | no zsh completion available | nothing to do |

### New and changed plugins

All paths are under `~/code/dot/zsh/zsh`.

`golangci-lint/golangci-lint.plugin.zsh`:

```zsh
#!/usr/bin/env zsh

_my-compdef-golangci-lint() {
  eval "$(golangci-lint completion zsh)" # zsh-lint disable=security/eval
  _golangci-lint "$@" # make the completion menu appear on first tab press
}

compdef _my-compdef-golangci-lint golangci-lint
```

`tree-sitter/tree-sitter.plugin.zsh`:

```zsh
#!/usr/bin/env zsh

_my-compdef-tree-sitter() {
  eval "$(tree-sitter complete --shell zsh)" # zsh-lint disable=security/eval
  _tree-sitter "$@" # make the completion menu appear on first tab press
}

compdef _my-compdef-tree-sitter tree-sitter
```

`uv/uv.plugin.zsh`:

```zsh
#!/usr/bin/env zsh

_my-compdef-uv() {
  eval "$(uv generate-shell-completion zsh)" # zsh-lint disable=security/eval
  _uv "$@" # make the completion menu appear on first tab press
}

_my-compdef-uvx() {
  eval "$(uvx --generate-shell-completion zsh)" # zsh-lint disable=security/eval
  _uvx "$@" # make the completion menu appear on first tab press
}

compdef _my-compdef-uv uv
compdef _my-compdef-uvx uvx
```

`aws/aws.plugin.zsh`: replace the hard-coded `/usr/bin/aws_completer` so it follows whichever `aws` is first on `PATH`:

```zsh
#!/usr/bin/env zsh

complete -C "${commands[aws_completer]}" aws
```

Then load the three new plugins from `.zshrc`, next to the `linecast` block and guarded the same way:

```zsh
# golangci-lint

if (( $+commands[golangci-lint] )); then
  zi ice lucid nocompletions wait'0' && zi light "$ZDOTDIR"/golangci-lint
fi
```

Do the same for `tree-sitter` and `uv`. The `uv` guard covers both `uv` and `uvx`.

### Check before relying on it

- **Guard timing:** `.zshrc` loads the `mise` plugin with `wait'0'`, so `mise activate` runs after the file has been read. A guard like `(( $+commands[aws] ))` runs while the file is read, so it can fail when `aws` only comes from mise. The `aws` block in `.zshrc` is already guarded this way, and the comment above the `mise` plugin ("before mise managed tools commands checks") suggests you have dealt with this for other tools. Test with a fresh shell: `zsh -ic 'print $+commands[aws] $+commands[golangci-lint]'`. If it prints `0`, either move the mise plugin out of turbo mode or drop the guards for these tools.
- **`compdef` function names:** the generated functions are `_golangci-lint`, `_tree-sitter`, `_uv` and `_uvx`. Check them with `which _uv` after the first tab in each case. If a name differs, adjust the call in the plugin.
- **Stale completions:** the `.zshrc` runs compinit with `-C`, which skips the check that rebuilds the cache. After removing the pacman packages, delete `$XDG_CACHE_HOME/zsh/zcompdump*` so zsh stops pointing at removed `_uv`, `_tree-sitter` and `_golangci-lint` files.
- **Order of removal:** add the plugins and confirm completion works with the mise copies before running `pacman -Rns`. Otherwise you have a period with no completion.

### Plan

1. Add the new plugins and change `aws.plugin.zsh` in `~/code/dot`.
2. Load them from `.zshrc` with `$+commands` guards.
3. In a fresh shell, confirm that `golangci-lint <tab>`, `tree-sitter <tab>`, `uv <tab>`, `uvx <tab>` and `aws s3 <tab>` complete.
4. Remove the pacman packages, delete the zcompdump files, and confirm again.
