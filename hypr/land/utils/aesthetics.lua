local v = require 'land.vars'
local AESTHETIC = {}

-- Convenience function for gradient syntax
---@param top string
---@param bottom string
---@param angle number?
---@return { colors: string[], angle: integer }
function AESTHETIC.gradient(top, bottom, angle)
  angle = angle or 80
  return {
    colors = { top .. v.alphas.high, bottom .. v.alphas.high },
    angle = angle,
  }
end

-- Fetch paths from BACKGROUND[i] environment variables
local bgs = {}
for i = 0, 9 do
  local bg = os.getenv(string.format('BACKGROUND%d', i))
  if bg then
    bgs[i] = bg
  end
end

-- Retrieve a background path based on workspace name
---@param s string
---@return string?
function AESTHETIC.fetchbackground(s)
  if not bgs then
    return nil
  end
  local numbered = tonumber(s)
  if numbered then
    return bgs[numbered % (#bgs + 1)]
  end
  local named = os.getenv(string.format('BACKGROUND%s', s))
  if named then
    return named
  end
  return nil
end

-- Convert time measurements to AWWW steps
---@param sec number
---@param hz number
---@return integer
function AESTHETIC.secs2step(sec, hz)
  if sec == 0 then
    return 255
  end
  return math.floor((256 / hz) * (1 / sec))
end

-- Run AWWW with a wipe animation
---@param wsp HL.Workspace
---@param step integer
---@param angle number
function AESTHETIC.runawwwanim(wsp, step, angle)
  local name = wsp.name
  local mon = wsp.monitor.name
  local bg = AESTHETIC.fetchbackground(name)
  local hz = math.ceil(wsp.monitor.refresh_rate)
  hl.dispatch(
    hl.dsp.exec_cmd(string.format('awww img --outputs %s --transition-fps %d --transition-step %d --transition-angle %d %s', mon, hz, step, angle, bg))
  )
end

-- Run AWWW with no animation
---@param wsp HL.Workspace
function AESTHETIC.runawwwstatic(wsp)
  local name = wsp.name
  local mon = wsp.monitor.name
  local bg = AESTHETIC.fetchbackground(name)
  hl.exec_cmd(string.format('awww img --outputs %s --transition-type none %s', mon, bg))
end

return AESTHETIC
