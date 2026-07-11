# BUGS

Findings from reviewing the `player` host journal for 2026-06-19 through 2026-07-10.

## Worth fixing

- **wireplumber crashes (SIGSEGV in `libasound.so.2`)** — two coredumps, 2026-06-11 and 2026-07-10.
  Both preceded by `spa.alsa: Error opening low-level control device 'hw:0': No such file or
  directory` and `can't open control for card hw:0`. Likely crashes while probing a stale or
  disconnected ALSA card (`hw:0`). Needs investigation into what's on card 0 (onboard/HDMI audio
  flapping?) — possibly an `alsa-lib`/`pipewire` version issue or a device quirk to add.

- **Stale NVIDIA module parameter** — `etc/modprobe.d/nvidia.conf` sets
  `NVreg_UsePageAttributeTable=1`, but the journal logs `nvidia: unknown parameter
  'NVreg_UsePageAttributeTable' ignored` on every module load. The open kernel module
  (610.43.02) has dropped this option. Remove it from `nvidia.conf`.

- **colord permission denied on color profile** — `Failed to create color profile from colord
  profile: Error opening file /home/greg/.local/share/icc/mpg321urx.icm: Permission denied`,
  6 occurrences, tied to gnome-shell restarts on `player`. `settings.sh` calls `colormgr
  import-profile` on this file for the `MPG321UX OLED` profile. Check real ownership/permissions
  of `~/.local/share/icc` on the machine directly (not verifiable from a sandboxed shell).

- **`asus_wmi: failed to register LPS0 sleep handler`** — logged every boot. Affects modern
  (`s2idle`) suspend/resume power state handling on the ASUS board. Check BIOS S0ix/ACPI settings
  if suspend is relied upon.

## Lower priority / mostly noise

- `sched_ext: Writing directly to p->scx.slice/dsq_vtime is deprecated` (35 occurrences) —
  kernel-level deprecation warning from the CachyOS scx scheduler. Not broken yet, but the
  direct-write API is slated for removal upstream; will need a scheduler update eventually.

