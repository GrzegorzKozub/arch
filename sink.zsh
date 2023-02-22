#!/usr/bin/env zsh

ALL=$(pactl list short sinks | cut -f2)

NOW=0
while true; do


 echo $ALL | while read -r name; do
    if [[ $NOW == 1 ]]; then
      pactl set-default-sink $name
      
      
    if [[ $(pactl info | grep 'Default Sink' | cut -d' ' -f3) == "$name" ]]; then
      return
    fi
    fi

    if [[ $(pactl info | grep 'Default Sink' | cut -d' ' -f3) == "$name" ]]; then
      NOW=1
    fi

  done
 
done



