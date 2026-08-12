local v = require 'land.variables'
local b = require 'land.utils.binds'
local s = require 'land.utils.scripts'
local k = b.k

-- Applications & Functions
hl.bind(k 'Escape', hl.dsp.exec_cmd(v.cmds.logout))
hl.bind(k 'Q', hl.dsp.exec_cmd(v.apps.power), { desc = '[Q]uit' })
hl.bind(k 'W', hl.dsp.exec_cmd(v.apps.notes), { desc = '[W]rite' })
hl.bind(k 'E', hl.dsp.exec_cmd(v.apps.emoji), { desc = '[E]moji' })
hl.bind(k 'R', hl.dsp.exec_cmd(v.cmds.refresh), { desc = '[R]efresh' })
hl.bind(k 'P', hl.dsp.exec_cmd(v.apps.password), { desc = '[P]asswords' })
hl.bind(k 'A', hl.dsp.exec_cmd(v.apps.menu), { desc = '[A]pplication' })
hl.bind(k 'S', function()
  local special = hl.get_active_special_workspace()
  if special and special.tiled_layout == 'scrolling' then
    hl.dispatch(hl.dsp.layout 'fit all')
  else
    hl.dispatch(hl.dsp.layout 'togglesplit')
  end
end, { desc = 'Swap / Shrink' })
hl.bind(k 'D', hl.dsp.exec_cmd(v.apps.files), { desc = '[D]irectory' })
hl.bind(k 'F', hl.dsp.window.float(), { desc = '[F]loat' })
hl.bind(k('ALT', 'F'), hl.dsp.window.fullscreen { mode = 'fullscreen', action = 'toggle' })
hl.bind(k 'Z', hl.dsp.group.toggle(), { desc = '[Z]ip' })
hl.bind(k 'X', hl.dsp.window.close(), { desc = 'e[X]it' })
hl.bind(k 'C', function()
  local terms = { 'foot', 'footclient', 'kitty' }
  local win = hl.get_active_window()
  for _, term in ipairs(terms) do
    if win and win.class == term then
      hl.dispatch(hl.dsp.send_shortcut {
        mods = 'CTRL, SHIFT',
        key = 'n',
        window = win,
      })
      return
    end
  end
  hl.exec_cmd(v.apps.terminal)
end, { desc = '[C]onsole' })
hl.bind(k 'V', function()
  if hl.get_config 'cursor.zoom_factor' == 1 then
    hl.config { cursor = { zoom_factor = 2 } }
  else
    hl.config { cursor = { zoom_factor = 1 } }
  end
end, { desc = '[V]iew' })
-- local super = m.gate()
-- hl.bind(k('SUPER', 'SUPER_L'), function()
--   m.doubletap(function()
--     hl.dispatch(hl.dsp.group.toggle())
--   end, super, 250)
-- end, { ignore_mods = true, desc = 'Window in Window' })

-- Movement & Resizing
local move = {
  dir = { 'r', 'l', 'd', 'u' },
  vim = { 'l', 'h', 'j', 'k' },
  arr = { 'right', 'left', 'down', 'up' },
}

for i = 1, 4 do
  hl.bind(k(move.vim[i]), function()
    b.focus_groupaware(move.dir[i])
  end, { repeating = true })
  hl.bind(k(move.arr[i]), function()
    b.focus_groupaware(move.dir[i])
  end, { repeating = true })
  hl.bind(k('CTRL', move.vim[i]), hl.dsp.focus { direction = move.dir[i] }, { repeating = true })
  hl.bind(k('CTRL', move.arr[i]), hl.dsp.focus { direction = move.dir[i] }, { repeating = true })
  hl.bind(k('ALT', move.vim[i]), function()
    b.move_groupaware(move.dir[i])
  end)
  hl.bind(k('ALT', move.arr[i]), function()
    b.move_groupaware(move.dir[i])
  end)
  hl.bind(k('CTRL', 'ALT', move.vim[i]), hl.dsp.window.move { direction = move.dir[i] })
  hl.bind(k('CTRL', 'ALT', move.arr[i]), hl.dsp.window.move { direction = move.dir[i] })
  hl.bind(k('SHIFT', move.vim[i]), function()
    b.translate(i)
  end, { repeating = true })
  hl.bind(k('SHIFT', move.arr[i]), function()
    b.translate(i)
  end, { repeating = true })
end

for i = 0, 9 do
  local ws = tostring(i)
  local name = ws
  if i < 1 then
    name = 'name:' .. name
  end
  hl.bind(k(ws), hl.dsp.focus { workspace = name, on_current_monitor = true })
  hl.bind(k('ALT', ws), hl.dsp.window.move { workspace = name, follow = false })
end
hl.bind(k 'Space', hl.dsp.workspace.toggle_special 's')
hl.bind(k('ALT', 'Space'), hl.dsp.window.move { workspace = 'special:s' })

-- Mouse Controls
hl.bind(k 'mouse_down', hl.dsp.focus { workspace = 'e+1' })
hl.bind(k 'mouse_up', hl.dsp.focus { workspace = 'e-1' })
hl.bind(k 'mouse:272', hl.dsp.window.drag(), { mouse = true })
hl.bind(k 'mouse:273', hl.dsp.window.resize(), { mouse = true })

-- Multimedia & Brightness Keys
hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_cmd 'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+', { locked = true, repeating = true })
hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-', { locked = true, repeating = true })
hl.bind('XF86AudioMute', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle', { locked = true, repeating = true })
hl.bind('XF86AudioMicMute', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle', { locked = true, repeating = true })
hl.bind('XF86MonBrightnessUp', hl.dsp.exec_cmd 'brightnessctl -e4 -n2 set 5%+', { locked = true, repeating = true })
hl.bind('XF86MonBrightnessDown', hl.dsp.exec_cmd 'brightnessctl -e4 -n2 set 5%-', { locked = true, repeating = true })

hl.bind('XF86AudioNext', hl.dsp.exec_cmd 'playerctl next', { locked = true })
hl.bind('XF86AudioPause', hl.dsp.exec_cmd 'playerctl play-pause', { locked = true })
hl.bind('XF86AudioPlay', hl.dsp.exec_cmd 'playerctl play-pause', { locked = true })
hl.bind('XF86AudioPrev', hl.dsp.exec_cmd 'playerctl previous', { locked = true })

-- Screenshot & Colorpicking
hl.bind('Print', hl.dsp.exec_cmd(s.screenshot 'snippet'))
hl.bind(k 'Print', hl.dsp.exec_cmd(s.screenshot 'select'))
hl.bind('ALT + Print', hl.dsp.exec_cmd 'hyprpicker -rau 64 -s 4')
