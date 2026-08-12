local v = require 'land.variables'
local a = require 'land.utils.aesthetics'
local track = require 'land.utils.tracking'

-- Disable grouping after closing a window in a group of 2
hl.on('window.close', function(win)
  if win.group and win.group.size <= 2 then
    hl.dispatch(hl.dsp.group.toggle(win))
  end
end)
-- Track most recent workspace
hl.on('monitor.focused', function(mon)
  track.wsp_active(mon.active_workspace)
end)
-- Track most recent window
hl.on('window.active', function(win, code)
  if not win.floating and not win.fullscreen and code ~= 16 then
    track.window_active(win)
  end
end)

-- Switch wallpapers on workspace switch
hl.on('workspace.active', function(ws)
  local old = track.wsp_active(ws)
  if old then
    for _, win in ipairs(ws.get_windows(old)) do
      if not win.floating then
        a.runawwwstatic(ws)
        return
      end
    end
  end
  local step = a.secs2step(v.transstep, ws.monitor.refresh_rate)
  local angle = old and math.abs(old.id) > math.abs(ws.id) and 175 or 5
  a.runawwwanim(ws, step, angle)
end)

hl.on('workspace.move_to_monitor', function(ws, mon)
  local old = track.wsp_monitors(ws)
  if old then
    for _, win in ipairs(ws.get_windows(old.active_workspace)) do
      if not win.floating then
        a.runawwwstatic(ws)
        return
      end
    end
  end
  local step = a.secs2step(v.transstep, mon.refresh_rate)
  local angle = old and old.position.x > mon.position.x and 175 or 5
  a.runawwwanim(ws, step, angle)
end)
