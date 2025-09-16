local wezterm = require 'wezterm'
local config = {}

config.hide_tab_bar_if_only_one_tab=true
config.macos_fullscreen_extend_behind_notch = true
config.font = wezterm.font "Fira Code"

config.default_prog = { '/Users/thblt/.nix-profile/bin/fish', '-l' }

function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'DoomOne'
  else
    return 'AtomOneLight'
  end
end

  config.color_scheme = scheme_for_appearance(get_appearance())
  return config
