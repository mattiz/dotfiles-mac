
#!/bin/bash

# Show notification if AeroSpace process is missing

aerospace_running=(
  icon=􀀁
  icon.font="$FONT:Black:8.0"
  icon.padding_right=2
  label.align=right
  padding_left=15
  updates=on
  update_freq=3
  script="$PLUGIN_DIR/aerospace_running.sh"
)

sketchybar --add item aerospace_running right       \
           --set aerospace_running "${aerospace_running[@]}"
