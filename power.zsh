#!/usr/bin/env zsh

set -e -o verbose

# cpu

echo 'w /sys/devices/system/cpu/cpufreq/policy?/energy_performance_preference - - - - balance_power' > \
  /etc/tmpfiles.d/energy_performance_preference.conf

# audio

echo 'options snd_hda_intel power_save=1' > /etc/modprobe.d/audio_powersave.conf

# wifi

echo 'options iwlwifi power_save=1' > /etc/modprobe.d/iwlwifi.conf

# writeback time

echo 'vm.dirty_writeback_centisecs = 6000' > /etc/sysctl.d/dirty.conf

