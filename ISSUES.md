# Undocumented journal findings — worker

Findings from inspecting the journal of the last full boot on `worker` (boot `fe1e2dca75f74e0dacd8cbad7afed6c0`, 2026-09-18 08:50–09:40), cross-checked against the 3 preceding boots (`-3`, `-2`, `-1`) for consistency — only issues present in all 4 are listed. Excludes anything already covered by `README.md`'s **Issues**/**Cosmetic** sections (activation noise, colord `ProtectHome`, bluetooth/rfkill, `asus_wmi`, alsa-lib/WirePlumber).

Dropped after the 4-boot check for not being boot-consistent:
- Bluetooth `hci0` firmware download failures (`FW download error recovery failed`, etc.) — absent in boots `-3` and `-2`.
- overlayfs file-handle fallback for Docker — only appeared in boot `0`; tied to container activity, not boot, so not a per-boot issue.

Not yet confirmed on `drifter`/`player` — check there before folding any of these into `README.md`.

## 1. ata5: failed to resume link

```
kernel: ata5: failed to resume link (SControl 0)
```

Every boot. `worker` has two NVMe drives and no SATA disks — this is an unpopulated SATA port on the board failing link power management. Harmless.

## 2. ACPI SystemIO/OpRegion conflict

```
kernel: ACPI Warning: SystemIO range 0x0000000000000B00-0x0000000000000B08 conflicts with OpRegion 0x0000000000000B00-0x0000000000000B0F (\GSA1.SMBI) (20260408/utaddress-204)
```

Every boot. Motherboard firmware's SMBus OpRegion overlaps a reserved I/O range. Cosmetic ACPI table quirk, not actionable from the OS side.

## 3. gsd-power backlight assertion

```
gsd-power[...]: gsd_power_backlight_abs_to_percentage: assertion 'max > min' failed
```

×4 per boot. `worker` is a desktop with monitors, not a laptop — `/sys/class/backlight/` is empty (confirmed). `gnome-settings-daemon`'s power plugin assumes a backlight device exists. Harmless.

## 4. GDM greeter shell teardown (xwayland/GlobalShortcutsProvider) — ROOT CAUSE FOUND

```
gnome-shell[1002]: Connection to xwayland lost
gnome-shell[1002]: Gio.DBusError: GDBus.Error:org.freedesktop.DBus.Error.ServiceUnknown: The name is not activatable
gnome-control-center-global-shortcuts-provider[...]: Lost connection to Wayland compositor.
systemd[958]: dbus-:1.2-org.gnome.Settings.GlobalShortcutsProvider@0.service: Main process exited, code=exited, status=1/FAILURE
systemd[958]: dbus-:1.2-org.gnome.Settings.GlobalShortcutsProvider@0.service: Failed with result 'exit-code'.
gnome-shell[1002]: meta_window_set_stack_position_no_sync: assertion 'window->stack_position >= 0' failed
gnome-shell[1002]: Error in size change accounting.
```

Every boot, at login. `gnome-shell[1002]` is **GDM's own greeter compositor** (confirmed: it starts at 08:50:47 logging "Running GNOME Shell ... as a Wayland display server" for `org.gnome.Shell@gdm.service`, not the user session). At 08:50:58, right after login, systemd tears down the greeter's shell:

1. The greeter's Xwayland is killed → `Connection to xwayland lost`, then an in-flight async D-Bus call throws because the name is no longer activatable.
2. The greeter's own `gnome-control-center-global-shortcuts-provider` helper loses its Wayland connection in the same moment and exits 1, which systemd logs as `Failed with result 'exit-code'` for its transient dbus-activated unit.

Normal GDM greeter → user-session handoff race, happens on every login, does not affect the actual user session. Same category as the existing **Activation noise** entry — cosmetic, just for the greeter shell specifically rather than D-Bus service activation.

## 5. setpci "kernel-exclusive config offset" — ROOT CAUSE FOUND

```
kernel: pci 0000:00:00.0: setpci: Unexpected write to kernel-exclusive config offset d
```

Every boot, during `perf.sh`. Caused directly by this repo:

```bash
# perf.sh:23
sudo setpci -v -s '0:0' latency_timer=0
```

`0:0` selects PCI device `0000:00:00.0` — the host bridge / root complex. The kernel treats config offset `0x0d` (the latency-timer register) on that device as kernel-exclusive and silently rejects the write. `setpci` still exits 0 (script doesn't fail under `set -eo pipefail`), so the [Arch wiki PCIe latency tweak](https://wiki.archlinux.org/title/Gaming#Improve_PCI_Express_Latencies) simply no-ops on the root complex — no functional effect, just log noise every boot.

Fix options: drop the `sudo setpci -v -s '0:0' latency_timer=0` line (it does nothing on this hardware), or leave it and document the warning as expected.

## 6. malcontent-timerd assertion

```
malcontent-timerd[...]: mct_time_span_new: assertion 'start_time_secs < end_time_secs' failed
malcontent-timerd[...]: mct_time_span_free: assertion 'self != NULL' failed
```

Once per boot. Parental-controls/screen-time daemon (`malcontent`) hitting a bad time-span calculation, likely because there's no configured screen-time limit for this user. Cosmetic.

## Cross-check on `player`

Checked the 3 most recent boots on `player` (boot IDs `-2`, `-1`, `0`, 2026-09-19 10:20–10:49) against all 6 issues above.

Boot-consistent on `player` too (ready to fold into `README.md`):
- #3 gsd-power backlight assertion
- #5 `setpci` kernel-exclusive config offset
- #6 malcontent-timerd assertion

Not applicable to `player` — absent in all 3 boots (hardware-specific to `worker`):
- #1 `ata5: failed to resume link`
- #2 ACPI SystemIO/OpRegion conflict

Not boot-consistent on `player` — full sequence appears in boots `-2` and `-1`, but boot `0` only shows a single `Connection to xwayland lost` with no `Failed with result 'exit-code'` / `Main process exited` lines. Needs more boots before folding in:
- #4 GDM greeter shell teardown (xwayland/GlobalShortcutsProvider)
