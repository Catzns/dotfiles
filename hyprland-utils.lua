local alphas = {
  high = 'ee',
  mid = 'cc',
  low = 'aa',
}
local M = {}

-- [[ TYPES ]]
---@alias selections { c: string?, t: string? }[]
---@alias resizes { c: string?, t: string?, x: integer?, y: integer? }[]

-- [[ GENERIC ]]
---@param value number
---@param size number
---@return number
function M.mod(value, size)
  return value ~= 0 and ((value - 1) % size) + 1 or 0
end

---@param v any
---@param n integer
function M.dup(v, n)
  local dups = {}
  for _ = 1, n do
    table.insert(dups, v)
  end
  return unpack(dups)
end

-- [[ MONITORS ]]
---@return { name: string, pos: string, scale: string }[]?
function M.buildmonitors()
  local monitors = {}
  local count = 1
  local name = os.getenv 'MONITOR1NAME'
  local pos = os.getenv 'MONITOR1POS'
  local scale = os.getenv 'MONITOR1SCALE'
  while name do
    table.insert(monitors, {
      name = name,
      pos = pos or 'auto',
      scale = scale or 'auto',
    })
    count = count + 1
    name = os.getenv(string.format('MONITOR%dNAME', count))
    pos = os.getenv(string.format('MONITOR%dPOS', count))
    scale = os.getenv(string.format('MONITOR%dSCALE', count))
  end
  return monitors
end

local mons = {}
for _, wsp in pairs(hl.get_workspaces()) do
  mons[wsp.name] = wsp.monitor
end
---@param wsp HL.Workspace?
---@return HL.Monitor?
function M.montrack(wsp)
  if not wsp then
    return nil
  end
  local mon = mons and mons[wsp.name] or nil
  mons[wsp.name] = wsp.monitor
  return mon
end

local ws = hl.get_active_workspace()
---@param new HL.Workspace?
---@return HL.Workspace?
function M.wstrack(new)
  if not new then
    return nil
  end
  local old = ws
  ws = new
  return old
end

-- [[ AESTHETICS ]]
---@param top string
---@param bottom string
---@return { colors: string[], angle: integer }
function M.border(top, bottom)
  return {
    colors = { top .. alphas.high, bottom .. alphas.high },
    angle = 80,
  }
end

---@return string[]?
function M.buildbackgrounds()
  local backgrounds = {}
  local count = 1
  local background = os.getenv 'BACKGROUND1'
  while background do
    table.insert(backgrounds, background)
    count = count + 1
    background = os.getenv(string.format('BACKGROUND%d', count))
  end
  return backgrounds
end

---@param bgs string[]?
---@param s string
---@return string?
function M.fetchbackground(bgs, s)
  if not bgs then
    return nil
  end
  local named = os.getenv(string.format('BACKGROUND%s', s))
  if named then
    return named
  end
  local numbered = tonumber(s)
  if numbered then
    if numbered == 0 then
      numbered = 10
    end
    return bgs[M.mod(numbered, #bgs)]
  end
  return nil
end

-- [[ KEYBINDS ]]
---@param mod string
---@param ... string
---@return string
function M.k(mod, ...)
  local keys = { ... }
  local combo = mod
  for _, key in ipairs(keys) do
    combo = combo .. ' + ' .. key
  end
  return combo
end

---@alias gate boolean[]
---@return gate
function M.gate()
  return { true }
end

---@param callback function
---@param gated gate
---@param timeout integer
function M.doubletap(callback, gated, timeout)
  if gated[1] then
    gated[1] = false
    hl.timer(function()
      gated[1] = true
    end, { timeout = timeout, type = 'oneshot' })
  else
    callback()
  end
end

---@param dir string
function M.move_groupaware(dir)
  if dir == 'l' or dir == 'r' then
    local forward = dir == 'r'
    local group = hl.get_active_window().group
    if group and ((forward and group.current_index < group.size) or (not forward and group.current_index > 1)) then
      hl.dispatch(hl.dsp.group.move_window { forward = forward })
      return
    end
  end
  hl.dispatch(hl.dsp.window.move { direction = dir, group_aware = true })
end

---@param i integer
function M.translate(i)
  local dist = hl.get_active_monitor().width / 20 or 0
  local axes = {
    { dist, 0 },
    { -dist, 0 },
    { 0, dist },
    { 0, -dist },
  }
  hl.dispatch(hl.dsp.window.resize { x = axes[i][1], y = axes[i][2], relative = true })
end

-- [[ REGEX ]]
---@param regexes string[]
---@return string
function M.rc(regexes)
  if #regexes < 1 then
    return ''
  end
  local r = string.format('(%s)', regexes[1])
  for i = 2, #regexes do
    r = string.format('%s|(%s)', r, regexes[i])
  end
  return r
end

---@param s string
---@return string
function M.rn(s)
  return 'negative:' .. s
end

-- [[ WINDOWS ]]
---@param name string
---@param selections selections
function M.buildrules(name, selections)
  local classes = {}
  local titles = {}
  for _, sel in ipairs(selections) do
    if sel.c and sel.t then
      hl.window_rule {
        match = {
          class = sel.c,
          title = sel.t,
        },
        tag = '+' .. name,
      }
    else
      if sel.c then
        table.insert(classes, sel.c)
      end
      if sel.t then
        table.insert(titles, sel.t)
      end
    end
  end
  if #classes > 0 then
    hl.window_rule {
      name = name .. '-class',
      match = { class = M.rc(classes) },
      tag = '+' .. name,
    }
  end
  if #titles > 0 then
    hl.window_rule {
      name = name .. '-title',
      match = { title = M.rc(titles) },
      tag = '+' .. name,
    }
  end
end

-- [[ EVENTS ]]
---@param resizes resizes
function M.buildresizes(resizes)
  hl.on('window.open', function(win)
    local dist = win.monitor.width / 20
    local mid = win.monitor.width / 2
    for _, resize in pairs(resizes) do
      local c = string.match(win.class, string.format('^%s$', resize.c))
      local t = string.match(win.title, string.format('^%s$', resize.t))
      if (c and resize.c) and (t and resize.t) then
        hl.dispatch(hl.dsp.window.resize {
          x = resize.x and (mid + dist * resize.x) or win.size.x,
          y = resize.y and (mid + dist * resize.y) or win.size.y,
          window = win,
        })
        return
      end
    end
  end)
end

-- [[ SCRIPTS ]]
---@param func 'select' | 'snippet'
---@return string
function M.screenshot(func)
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

return M
