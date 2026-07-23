local BINDS = {}

-- Convenience function for building WM keybinds
---@param first string
---@param ... string
---@return string
function BINDS.k(first, ...)
  local keys = { ... }
  local combo = 'SUPER + ' .. first
  for _, key in ipairs(keys) do
    combo = combo .. ' + ' .. key
  end
  return combo
end

-- Tables are necessary for out of scope side effects in Lua
---@return gate
function BINDS.gate()
  return { true }
end

-- Execute a callback upon pressing a key twice in [timeout] ms or less
---@param callback function
---@param gated gate
---@param timeout integer
function BINDS.doubletap(callback, gated, timeout)
  if gated[1] then
    gated[1] = false
    hl.timer(function()
      gated[1] = true
    end, { timeout = timeout, type = 'oneshot' })
  else
    callback()
  end
end

-- Merge group cycling and window focus into a single bind
---@param dir string
function BINDS.focus_groupaware(dir)
  local config = hl.get_config 'binds.movefocus_cycles_groupfirst'
  hl.config { binds = { movefocus_cycles_groupfirst = true } }
  hl.dispatch(hl.dsp.focus { direction = dir })
  hl.config { binds = { movefocus_cycles_groupfirst = config } }
end

-- If adjacent to a group, move a window into it, otherwise move it normally
---@param dir string
function BINDS.move_groupaware(dir)
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

-- Resize windows by constant units consistent with Hyprland's minimum window size
---@param i integer
function BINDS.translate(i)
  local dist = hl.get_active_monitor().width / 20 or 0
  local axes = {
    { dist, 0 },
    { -dist, 0 },
    { 0, dist },
    { 0, -dist },
  }
  hl.dispatch(hl.dsp.window.resize { x = axes[i][1], y = axes[i][2], relative = true })
end

return BINDS
