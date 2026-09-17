#!/bin/sh

sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_window_move
sketchybar --add event aerospace_windows_change

for m in $(aerospace list-monitors | awk '{print $1}'); do
  for i in $(aerospace list-workspaces --monitor $m); do
    sid=$i
    space=(
      space="$sid"
      icon="$sid"
      icon.highlight_color=$RED
      icon.padding_left=10
      icon.padding_right=10
      display=$m
      padding_left=2
      padding_right=2
      label.padding_right=20
      label.color=$GREY
      label.highlight_color=$WHITE
      label.font="sketchybar-app-font:Regular:16.0"
      label.y_offset=-1
      background.color=$BACKGROUND_1
      background.border_color=$BACKGROUND_2
      script="$PLUGIN_DIR/space.sh"
    )

    sketchybar --add space space.$sid left \
               --set space.$sid "${space[@]}" \
               --subscribe space.$sid mouse.clicked

  done

  for i in $(aerospace list-workspaces --monitor $m --empty); do
    sketchybar --set space.$i display=0
  done
  
done


space_creator=(
  icon=􀆊
  icon.font="$FONT:Heavy:16.0"
  padding_left=10
  padding_right=8
  label.drawing=off
  display=active
  script="$PLUGIN_DIR/space_windows.sh"
  icon.color=$WHITE
)

sketchybar --add item space_creator left               \
           --set space_creator "${space_creator[@]}"   \
           --subscribe space_creator aerospace_workspace_change aerospace_window_move


# Hidden item keeping the icon strips current. Opening a window shows up as
# aerospace_windows_change (AeroSpace's on-focus-changed); closing one fires no
# AeroSpace callback at all, so space_windows_change covers that side. The poll
# is a safety net at ~17ms of AeroSpace CPU a time. updates=on is required: the
# default when_shown never updates an item with drawing=off.
window_watcher=(
  drawing=off
  updates=on
  update_freq=2
  script="$PLUGIN_DIR/update_windows.sh"
)

sketchybar --add item window_watcher left \
           --set window_watcher "${window_watcher[@]}" \
           --subscribe window_watcher aerospace_windows_change space_windows_change

# Initial paint; --force drops caches left by a previous run
"$PLUGIN_DIR/update_windows.sh" --force
