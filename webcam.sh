#!/usr/bin/env bash
set -eo pipefail -u

[[ $HOST == 'drifter' ]] && RES='1280x720'
[[ $HOST == 'worker' ]] && RES='1920x1080'

[[ $HOST == 'drifter' && ${1:-} =~ ^zoom ]] && exit 1

get-zoom() {
  v4l2-ctl --device "$CAM" --get-ctrl=zoom_absolute | awk '{print $2}'
}

set-zoom() {
  v4l2-ctl --device "$CAM" --set-ctrl=zoom_absolute="$1"
  echo $ZOOM
}

CAM=$(v4l2-ctl --list-devices | grep -m1 '/dev' | tr -d '\t')
[[ -z $CAM ]] && exit 1

[[ ${1:-} == 'zoom-out' ]] && {
  ZOOM=$(get-zoom)
  ((ZOOM = ZOOM > 100 ? ZOOM - 10 : ZOOM))
  set-zoom $ZOOM
}

[[ ${1:-} == 'zoom-in' ]] && {
  ZOOM=$(get-zoom)
  ((ZOOM = ZOOM < 180 ? ZOOM + 10 : ZOOM))
  set-zoom $ZOOM
}

[[ -z ${1:-} || ${1:-} == 'preview' ]] && {
  ffplay -input_format mjpeg -video_size "$RES" -framerate 30 "$CAM" &> /dev/null
}

true
