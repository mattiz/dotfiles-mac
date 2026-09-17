#!/usr/bin/env bash

# Repaints the app icon strip for every workspace.
# Runs on every focus change and on a timer, so the unchanged path is kept to a
# single aerospace request and no sketchybar call at all.

CACHE="/tmp/sketchybar_space_icons"
WORKSPACES="/tmp/sketchybar_workspaces"

# --force: initial run after a config reload
[ "$1" = "--force" ] && rm -f "$CACHE" "$WORKSPACES"

# Sourced, not forked per window: gives us __icon_map/$icon_result
source "$CONFIG_DIR/plugins/icon_map.sh" "" > /dev/null

# Cached: this only changes with aerospace.toml, and every aerospace request
# costs ~15ms of server CPU regardless of what it asks for. -s rather than -f:
# an empty file means a previous run cached a failed lookup, so try again.
if [ -s "$WORKSPACES" ]; then
  workspaces=$(< "$WORKSPACES")
else
  workspaces=$(aerospace list-workspaces --all | tr '\n' ' ')
  # At login sketchybar can beat AeroSpace to the start. Bail rather than cache
  # an empty answer or blank the bar; the next event or poll retries.
  [ -z "${workspaces// /}" ] && exit 0
  printf '%s' "$workspaces" > "$WORKSPACES"
fi

# All windows in one call: "<workspace>|<app name>" per line
windows=$(aerospace list-windows --all --format '%{workspace}|%{app-name}') || exit 0

# Icons are mapped in-process; one awk then groups them per workspace and emits
# the sketchybar arguments, since bash 3.2 has no associative arrays.
mapped=""
while IFS='|' read -r ws app
do
  [ -z "$ws" ] && continue
  __icon_map "$app"
  mapped+="$ws|$icon_result"$'\n'
done <<< "$windows"

args=()
while IFS= read -r line
do
  args+=("$line")
done <<< "$(awk -F'|' -v wslist="$workspaces" '
  { icons[$1] = icons[$1] " " $2 }
  END {
    n = split(wslist, ws, " ")
    for (i = 1; i <= n; i++)
      printf "--set\nspace.%s\nlabel= %s\n", ws[i], (ws[i] in icons ? icons[ws[i]] : "—")
  }' <<< "$mapped")"

# Unchanged since last run: leave sketchybar alone
state="${args[*]}"
if [ -f "$CACHE" ] && [ "$state" = "$(< "$CACHE")" ]; then
  exit 0
fi
printf '%s' "$state" > "$CACHE"

sketchybar "${args[@]}"
