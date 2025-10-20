local wezterm = require 'wezterm'
local config = {}

config.hide_tab_bar_if_only_one_tab=true
config.macos_fullscreen_extend_behind_notch = true
config.font = wezterm.font "Fira Code"

if wezterm.target_triple == 'aarch64-apple-darwin' then
    config.default_prog = { '/Users/thblt/.nix-profile/bin/fish', '-l' }
end

config.native_macos_fullscreen_mode = false
config.macos_fullscreen_extend_behind_notch = true

config.color_scheme = "DoomOne"
-- function get_appearance()
--   if wezterm.gui then
--     return wezterm.gui.get_appearance()
--   end
--   return 'Dark'
-- end

-- function scheme_for_appearance(appearance)
--   if appearance:find 'Dark' then
--     return 'DoomOne'
--   else
--     return 'Github (base16)'
--   end
-- end

--   config.color_scheme = scheme_for_appearance(get_appearance())
  return config
