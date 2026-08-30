#!/usr/bin/env bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Unknown Model"')

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

if [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct")
  bar_width=20
  filled=$(( used_int * bar_width / 100 ))
  empty=$(( bar_width - filled ))
  bar=""
  for i in $(seq 1 $filled); do bar="${bar}█"; done
  for i in $(seq 1 $empty); do bar="${bar}░"; done

  if [ "$used_int" -ge 80 ]; then
    color="\033[0;31m"
  elif [ "$used_int" -ge 50 ]; then
    color="\033[0;33m"
  else
    color="\033[0;32m"
  fi
  reset="\033[0m"

  printf "%s  ${color}[%s]${reset} %d%% used" "$model" "$bar" "$used_int"
else
  printf "%s  [%s]" "$model" "no context data yet"
fi
