
#!/bin/bash

# Show which Kubernetes context is selected
k8s_context=(  
  label.align=right
  padding_left=15
  updates=on
  update_freq=3
  script="$PLUGIN_DIR/k8s_context.sh"
)

sketchybar --add item k8s_context right       \
           --set k8s_context "${k8s_context[@]}"
