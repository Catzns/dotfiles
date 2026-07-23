local TRACKING = {}

local MONITORS = {}
local WORKSPACE = hl.get_active_workspace()

for _, wsp in pairs(hl.get_workspaces()) do
  MONITORS[wsp.name] = wsp.monitor
end

-- Update a monitor's active workspace and return its previous workspace
---@param wsp HL.Workspace?
---@return HL.Monitor
function TRACKING.wsp_monitors(wsp)
  if not wsp then
    return MONITORS[1]
  end
  local monitor = MONITORS[wsp.name]
  MONITORS[wsp.name] = wsp.monitor
  return monitor
end
TRACKING.wsp_monitors(WORKSPACE)

-- Update the currently active workspace and return the previous workspace
---@param new HL.Workspace?
---@return HL.Workspace?
function TRACKING.wsp_active(new)
  if not new then
    return nil
  end
  local old = WORKSPACE
  WORKSPACE = new
  return old
end
TRACKING.wsp_active(WORKSPACE)

---@type HL.Window?
local WINDOW

-- Update the currently active windcow and return the previous window, if any
---@param win HL.Window?
---@return HL.Window?
function TRACKING.window_active(win)
  local old = WINDOW
  WINDOW = win
  return old or nil
end

return TRACKING
