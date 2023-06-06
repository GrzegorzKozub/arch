#!/usr/bin/env zsh

# set -e -o verbose

# support import timeouts
# handle errors better
# remove automatic profiles?


PROFILE=$(
  colormgr import-profile ~/code/arch/home/greg/.config/color/icc/devices/display/27ul850-w.icm |
    grep 'Profile ID' |
    sed -e 's/Profile ID:    //'
)

if [[ -z $PROFILE ]]; then

  PROFILE=$(
    colormgr find-profile-by-filename 27ul850-w.icm |
      grep 'Profile ID' |
      sed -e 's/Profile ID:    //'
  )

fi

DEVICE=$(colormgr find-device-by-property Model 'LG HDR 4K' | grep 'Device ID' | sed -e 's/Device ID:     //')

colormgr device-add-profile $DEVICE $PROFILE
colormgr device-make-profile-default $DEVICE $PROFILE


PROFILE=$(
  colormgr import-profile ~/code/arch/home/greg/.config/color/icc/devices/display/27ud88-w.icm |
    grep 'Profile ID' |
    sed -e 's/Profile ID:    //'
)

if [[ -z $PROFILE ]]; then

  PROFILE=$(
    colormgr find-profile-by-filename 27ud88-w.icm |
      grep 'Profile ID' |
      sed -e 's/Profile ID:    //'
  )

fi

DEVICE=$(colormgr find-device-by-property Model 'LG Ultra HD' | grep 'Device ID' | sed -e 's/Device ID:     //')

colormgr device-add-profile $DEVICE $PROFILE
colormgr device-make-profile-default $DEVICE $PROFILE

