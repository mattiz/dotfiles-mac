#!/bin/bash

slack=(
    icon=􁒘
    icon.font="$FONT:Black:12.0"
    icon.padding_right=2
    label.align=right
    padding_left=15
    updates=on
    update_freq=3
    script="$PLUGIN_DIR/slack.sh"
)

sketchybar --add item slack right        \
           --set slack "${slack[@]}"