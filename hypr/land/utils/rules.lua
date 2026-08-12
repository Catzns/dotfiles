local r = require 'land.utils.regex'
local v = require 'land.variables'
local track = require 'land.utils.tracking'
local RULES = {}

---@param name string
---@param selections selections
function RULES.buildrules(name, selections)
  local classes = {}
  local titles = {}
  for _, sel in ipairs(selections) do
    if sel.c and sel.t then
      hl.window_rule {
        tag = '+' .. name,
        match = {
          class = sel.c,
          title = sel.t,
        },
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
      tag = '+' .. name,
      match = { class = r.c(classes) },
    }
  end
  if #titles > 0 then
    hl.window_rule {
      name = name .. '-title',
      tag = '+' .. name,
      match = { title = r.c(titles) },
    }
  end
end

hl.on('window.open', function(win)
  local old = track.window_active(win)
  if not old or win.workspace.windows < 2 then
    return
  end
  local dist = win.monitor.width / 20
  local mid = win.monitor.width / 2
  for _, resize in pairs(v.resizes) do
    local c = string.match(win.class, string.format('^%s$', resize.c))
    local t = string.match(win.title, string.format('^%s$', resize.t))
    if (not c == not resize.c) and (not t == not resize.t) then
      local rx = resize.x
      local ry = resize.y
      if rx and old.at.x < win.at.x then
        rx = -rx
      end
      if ry and old.at.y < win.at.y then
        ry = -ry
      end
      hl.dispatch(hl.dsp.window.resize {
        x = rx and (mid + dist * rx) or win.size.x,
        y = ry and (mid + dist * ry) or win.size.y,
        window = win,
      })
      return
    end
  end
end)

return RULES
