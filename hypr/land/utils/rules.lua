local r = require 'land.utils.regex'
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

return RULES
