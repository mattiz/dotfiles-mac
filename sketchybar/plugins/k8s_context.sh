#!/bin/sh

source "$CONFIG_DIR/colors.sh"

CONTEXT="$(kubectl config current-context)"
LABEL=$CONTEXT

sketchybar --set "$NAME" label="$LABEL"
