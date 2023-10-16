#!/usr/bin/env zsh

set -e

# work around "Only the focused app is allowed to show a system access dialog" in journal
# https://github.com/flameshot-org/flameshot/issues/2868
# https://github.com/flameshot-org/flameshot/issues/3213

flameshot gui

