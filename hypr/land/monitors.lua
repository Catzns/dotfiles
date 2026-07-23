local MONITORS = {
  {
    output = 'DP-2',
    mode = 'highres',
    position = '0x0',
    scale = 'auto',
  },
  {
    output = 'HDMI-A-1',
    mode = 'highres',
    position = 'auto-right',
    scale = 'auto',
  },
}

for _, settings in ipairs(MONITORS) do
  hl.monitor {
    output = settings.output,
    mode = settings.mode,
    position = settings.position,
    scale = settings.scale,
  }
end

hl.monitor {
  output = '',
  mode = 'highres',
  position = 'auto',
  scale = 'auto',
}

return MONITORS
