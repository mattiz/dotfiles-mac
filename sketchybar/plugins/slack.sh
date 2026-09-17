#!/bin/bash

SLACK_INFO=$(lsappinfo -all info -only StatusLabel Slack 2>/dev/null)
COUNT=$(echo "$SLACK_INFO" | sed -n 's/.*"label"="\([^"]*\)".*/\1/p')

if [ -z "$COUNT" ] || [ "$COUNT" = "•" ]; then
  DRAWING=off
else
  DRAWING=on
fi

sketchybar --set slack drawing=$DRAWING label="${COUNT}"
