#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

echo "" >> ~/.debug

AEROSPACE_FOCUSED_MONITOR=$(aerospace list-monitors --focused | awk '{print $1}')
AEROSPACE_WORKSPACE_FOCUSED_MONITOR=$(aerospace list-workspaces --monitor focused --empty no)
AEROSPACE_EMPTY_WORKESPACE=$(aerospace list-workspaces --monitor focused --empty)

if [ "$SENDER" = "aerospace_window_move" ]; then
  CURRENTLY_FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

  echo "reload: FROM: $CURRENTLY_FOCUSED_WORKSPACE, TO: $AEROSPACE_RECEIVER_WORKSPACE" >> ~/.debug
  
  "$CONFIG_DIR/plugins/update_windows.sh"

   for i in $AEROSPACE_WORKSPACE_FOCUSED_MONITOR; do
    sketchybar --set space.$i display=$AEROSPACE_FOCUSED_MONITOR
  done
fi

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  echo "change: $AEROSPACE_FOCUSED_WORKSPACE" >> ~/.debug

  "$CONFIG_DIR/plugins/update_windows.sh"

  # current workspace space border color
  sketchybar --set space.$AEROSPACE_FOCUSED_WORKSPACE icon.highlight=true \
                         label.highlight=true \
                         background.border_color=$GREY

  # prev workspace space border color
  sketchybar --set space.$AEROSPACE_PREV_WORKSPACE icon.highlight=false \
                         label.highlight=false \
                         background.border_color=$BACKGROUND_2

  for i in $AEROSPACE_WORKSPACE_FOCUSED_MONITOR; do
    sketchybar --set space.$i display=$AEROSPACE_FOCUSED_MONITOR
  done

  for i in $AEROSPACE_EMPTY_WORKESPACE; do
    sketchybar --set space.$i display=0
  done

  sketchybar --set space.$AEROSPACE_FOCUSED_WORKSPACE display=$AEROSPACE_FOCUSED_MONITOR
fi
