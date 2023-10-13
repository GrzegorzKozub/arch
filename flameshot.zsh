#!/usr/bin/env zsh

set -e

flameshot gui

# When flameshot gui is bound directly to a keyboard skortcut then
# every time the Print Screen kee is pressed we get:
#
# xdg-desktop-por[4606]: Failed to show access dialog:
# GDBus.Error:org.freedesktop.DBus.Error.AccessDenied:
# Only the focused app is allowed to show a system access dialog
#
# Binding this script fixes this issue.
#
# https://github.com/flameshot-org/flameshot/issues/2868
# https://github.com/flameshot-org/flameshot/issues/3213

