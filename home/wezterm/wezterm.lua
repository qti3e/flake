local wezterm = require 'wezterm'

-- < start of wide screen window config
function recompute_padding(window)
  local window_dims = window:get_dimensions()
  local overrides = window:get_config_overrides() or {}

  local is_screen_large = window_dims.pixel_width > 5000

  if not is_screen_large then
    if not overrides.window_padding and not overrides.background then
      -- not changing anything
      return
    end
    overrides.window_padding = nil
    overrides.background = nil
  else
    local padding = (window_dims.pixel_width - 2200) / 2
    local new_padding = {
      left = padding,
      right = padding,
      top = '2.2cell',
      bottom = '2.0cell',
    }

    if
        overrides.window_padding
        and new_padding.left == overrides.window_padding.left
    then
      -- padding is same, avoid triggering further changes
      return
    end
    overrides.window_padding = new_padding
  end
  window:set_config_overrides(overrides)
end

wezterm.on('window-resized', function(window, pane)
  recompute_padding(window)
end)

wezterm.on('window-config-reloaded', function(window)
  recompute_padding(window)
end)
-- end of wide screen window config />


local tab_colors = {
  "Navy", "Red", "Green", "Olive", "Maroon", "Purple", "Teal", "Lime", "Yellow", "Blue", "Fuchsia", "Aqua"
}
local tab_bg = "rgba(22,22,22,0.8)"

wezterm.on(
  'format-tab-title',
  function(tab)
    if tab.is_active then
      local accent = tab_colors[(tab.tab_index % #tab_colors) + 1]
      return wezterm.format({
        { Background = { Color = tab_bg } },
        { Foreground = { AnsiColor = accent } },
        { Text = ' ' .. wezterm.nerdfonts.ple_left_half_circle_thick },
        { Background = { AnsiColor = accent } },
        { Foreground = { Color = tab_bg } },
        { Text = tostring(tab.tab_index) },
        { Background = { Color = tab_bg } },
        { Foreground = { AnsiColor = accent } },
        { Text = wezterm.nerdfonts.ple_right_half_circle_thick },
      })
    else
      return ' ' .. tab.tab_index
    end
  end
)

return {
  --default_prog = { "nvim", "+terminal", "+startinsert" },
  font = wezterm.font_with_fallback {
    'Berkeley Mono',
    --'Dank Mono',
    --'Gintronic',
    --'PragmataPro Mono Liga',
    --'Fira Code Nerd Font',
    'Symbols Nerd Font',
  },
  font_size = 16,
  window_background_opacity = 0.8,
  text_background_opacity = 1.0,
  -- window_decorations = "NONE",
  window_padding = {
    left = '1.5cell',
    right = '1.0cell',
    top = '0.2cell',
    bottom = '0.0cell',
  },
  color_scheme = "Carburator",
  inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 1.0,
  },
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  colors = {
    tab_bar = {
      active_tab = { bg_color = tab_bg, fg_color = "#f4f4f4" },
      inactive_tab = { bg_color = tab_bg, fg_color = "#f4f4f4" },
      inactive_tab_hover = { bg_color = tab_bg, fg_color = "#f4f4f4", italic = false }
    }
  },
  tab_bar_style = {
    new_tab = "",
    new_tab_hover = ""
  },
  tab_max_width = 32,
  hide_tab_bar_if_only_one_tab = true,
  default_cursor_style = 'BlinkingBlock',
  warn_about_missing_glyphs = false
}
