local wezterm = require 'wezterm'
local config = {}

config.hide_tab_bar_if_only_one_tab=true
config.macos_fullscreen_extend_behind_notch = true
config.font = wezterm.font "Fira Code"

config.default_prog = { '/Users/thblt/.nix-profile/bin/fish', '-l' }

config.color_scheme = "DoomOne"

return config
