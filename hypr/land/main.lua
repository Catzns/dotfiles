-- [[ TYPES ]]
---@alias selections { c: string?, t: string? }[]
---@alias resizes { c: string?, t: string?, x: integer?, y: integer? }[]

local v = require 'land.vars'
require 'land.monitors'
require 'land.config'
require 'land.binds'
require 'land.rules'
require 'land.events'

hl.on('hyprland.start', function()
  local tracking = hl.get_config 'misc.initial_workspace_tracking'
  hl.config { misc = { initial_workspace_tracking = 0 } }
  for _, program in pairs(v.startup) do
    hl.exec_cmd(program)
  end
  hl.config { misc = { initial_workspace_tracking = tracking } }
end)
