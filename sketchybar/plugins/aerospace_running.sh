#!/bin/sh

source "$CONFIG_DIR/colors.sh"

PID="$(pgrep AeroSpace)"

if [[ "$PID" != "" ]]; then
  ICON_COLOR=$GREEN
  LABEL=""
else
  ICON_COLOR=$RED
  LABEL="AeroSpace not running"
fi

sketchybar --set "$NAME" label="$LABEL" icon.color=${ICON_COLOR}
