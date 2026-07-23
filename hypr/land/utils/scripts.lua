local SCRIPTS = {}

-- [[ SCRIPTS ]]
---@param func 'select' | 'snippet'
---@return string
function SCRIPTS.screenshot(func)
  local script = [=[
func="%s"
cmd_screen="grim"
cmd_select="slurp"
cmd_freeze="hyprpicker -rz"
cmd_edit="swappy -f -"
cmd_copy="wl-copy"
cmd_end="pkill ${cmd_freeze/%% *}"

deps=("$cmd_screen" "$cmd_select")
optdeps=("$cmd_edit" "$cmd_copy")
if [[ "$func" == "snippet" ]]; then
  optdeps+=("$cmd_freeze")
fi

track=0
for dep in "${deps[@]}"; do
  dep="${dep/%% *}"
  if ! command -v "$dep"&>/dev/null; then 
    hyprctl notify 3 5000 0 "Utility '$dep' is not installed."
    track+=1
  fi
done
if [[ $track -ne 0 ]]; then
  exit 1
fi

for dep in "${optdeps[@]}"; do
  dep="${dep/%% *}"
  if ! command -v "$dep"&>/dev/null; then 
    hyprctl notify 0 5000 0 "Utility '$dep' is not installed."
  fi
done

if [[ "$func" == "snippet" ]]; then
  cmd_select="slurp -F 'JetBrains Mono' -b a9b1d633 -c c0caf5 -w 1 -d"
else
  cmd_select="slurp -F 'JetBrainsMono' -B a9b1d633 -c c0caf5 -w 9 -o -r"
fi
cmd_screen="grim -g \"\$($cmd_select)\" -"

cmd="$cmd_screen"
if command -v "${cmd_edit/%% *}"&>/dev/null; then
  cmd="$cmd | ($cmd_edit &)"
elif command -v "${cmd_copy/%% *}"&>/dev/null; then
  cmd="$cmd | $cmd_copy"
else
  cmd="$cmd&>/dev/null"
fi

if command -v "${cmd_freeze/%% *}"&>/dev/null; then
  cmd="$cmd_freeze & sleep 0.05; $cmd; $cmd_end"
fi

eval "$cmd"
]=]
  return string.format(script, func)
end

return SCRIPTS
