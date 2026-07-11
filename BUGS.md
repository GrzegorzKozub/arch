# BUGS

Findings from reviewing the `player` host journal for 2026-06-19 through 2026-07-10.

## Worth fixing

- **wireplumber crashes (SIGSEGV in `libasound.so.2`)** — two coredumps, 2026-06-11 and 2026-07-10.
  Both preceded by `spa.alsa: Error opening low-level control device 'hw:0': No such file or
  directory` and `can't open control for card hw:0`. Likely crashes while probing a stale or
  disconnected ALSA card (`hw:0`). Needs investigation into what's on card 0 (onboard/HDMI audio
  flapping?) — possibly an `alsa-lib`/`pipewire` version issue or a device quirk to add.

- **colord permission denied on color profile** — `Failed to create color profile from colord
  profile: Error opening file /home/greg/.local/share/icc/mpg321urx.icm: Permission denied`,
  6 occurrences, tied to gnome-shell restarts on `player`. `settings.sh` calls `colormgr
  import-profile` on this file for the `MPG321UX OLED` profile. Check real ownership/permissions
  of `~/.local/share/icc` on the machine directly (not verifiable from a sandboxed shell).

