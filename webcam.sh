#!/usr/bin/env bash
set -eo pipefail -u

# install gucview and add zoom controls

set-zoom() {
  v4l2-ctl --device "$CAM" --set-ctrl=zoom_absolute="$1"
}

CAM=$(v4l2-ctl --list-devices | grep -m1 '/dev' | tr -d '\t')
[[ -z $CAM ]] && exit 1

[[ ${1:-} == 'zoom-out' ]] && {
  ZOOM=$(v4l2-ctl --device "$CAM" --get-ctrl=zoom_absolute | awk '{print $2}')
  ((ZOOM = ZOOM > 100 ? ZOOM - 10 : ZOOM))
  set-zoom $ZOOM
  echo $ZOOM
}

[[ ${1:-} == 'zoom-in' ]] && {
  ZOOM=$(v4l2-ctl --device "$CAM" --get-ctrl=zoom_absolute | awk '{print $2}')
  ((ZOOM = ZOOM < 180 ? ZOOM + 10 : ZOOM))
  v4l2-ctl --device "$CAM" --set-ctrl=zoom_absolute=$ZOOM
  echo $ZOOM
}

[[ ${1:-} == 'preview' ]] && {
  ffplay -input_format mjpeg -video_size 1920x1080 -framerate 30 "$CAM" &> /dev/null
}

true
