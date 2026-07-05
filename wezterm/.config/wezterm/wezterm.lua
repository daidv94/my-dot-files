local wezterm = require("wezterm")
local action = wezterm.action
local mux = wezterm.mux
local os = require("os")
local io = require("io")

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Maximize window screen on start up
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- Tab configuration
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
-- config.tab_bar_at_bottom = true
config.show_tab_index_in_tab_bar = true

config.term = "xterm-256color"
config.max_fps = 200
config.check_for_updates = true

-- config.font = wezterm.font("FiraCode Nerd Font Mono")
config.font = wezterm.font("Lilex")
config.font_size = 15
config.window_frame = {
  font_size = 14.0,
}
config.color_scheme = "rose-pine"
config.colors = {
  -- Fix selection highlight: use rose-pine's highlight_med as bg so selected
  -- text is visually distinct from normal text
  selection_fg = "#e0def4", -- rose-pine text
  selection_bg = "#403d52", -- rose-pine highlight_med

  tab_bar = {
    background = "#191724", -- rose-pine base
    inactive_tab_hover = {
      bg_color = "#403d52", -- rose-pine highlight_med
      fg_color = "#e0def4", -- rose-pine text
    },
    new_tab = {
      bg_color = "#26233a", -- rose-pine overlay
      fg_color = "#908caa", -- rose-pine subtle
    },
    new_tab_hover = {
      bg_color = "#403d52",
      fg_color = "#e0def4",
    },
  },
}
config.window_background_opacity = 1 -- If image background is used, this will be ignored
-- config.macos_window_background_blur = 21
-- config.window_decorations = "RESIZE"
config.default_workspace = "main"

-- config.enable_tab_bar = false

-- Dim inactive panes
--
config.inactive_pane_hsb = {
  saturation = 1,
  brightness = 0.7,
}

config.use_ime = false

-- Image background setting
local home_dir = os.getenv("HOME")
local bg_dir = home_dir .. "/Pictures/Background"
local init_bg = bg_dir .. "/dota2.jpg"

local function random_background(folder)
  local handle = io.popen('ls "' .. folder .. '"')
  if handle == nil then
    return nil
  end
  local files = handle:read("*a")
  handle:close()

  local images = {}
  for file in string.gmatch(files, "[^\n]+") do
    table.insert(images, file)
  end
  if #images > 0 then
    return folder .. "/" .. images[math.random(#images)]
  end
  return nil
end

config.background = {
  {
    source = {
      File = init_bg,
    },
    -- Darken the background image by reducing it
    hsb = {
      brightness = 0.05,
      hue = 1,
      saturation = 0.8,
    },
  },
}

-- End image background settings

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function split_nav(key)
  return {
    key = key,
    mods = "CMD",
    action = wezterm.action.ActivatePaneDirection(direction_keys[key]),
  }
end

-- Keys
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1500 }
config.keys = {
  -- Double Ctrl-a to send Ctrl-a
  { key = "a", mods = "LEADER|CTRL", action = action.SendKey({ key = "a", mods = "CTRL" }) },
  -- Change the tab title name
  {
    key = ",",
    mods = "LEADER",
    action = action.PromptInputLine({
      description = "Enter new name for tab",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  -- Random background images
  {
    key = "b",
    mods = "CTRL|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      local new_background = random_background(bg_dir)
      if new_background then
        window:set_config_overrides({
          background = {
            {
              source = {
                File = new_background,
              },
              hsb = {
                brightness = 0.05,
                hue = 1.0,
                saturation = 0.8,
              },
            },
          },
        })
        wezterm.log_info("New bg:" .. new_background)
      else
        wezterm.log_error("Could not find bg image")
      end
    end),
  },
  split_nav("h"),
  split_nav("j"),
  split_nav("k"),
  split_nav("l"),
  -- splitting
  {
    mods = "LEADER",
    key = "-",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    mods = "LEADER",
    key = "\\",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    mods = "LEADER",
    key = "c",
    action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
  },
  -- Adjust the panel size
  {
    key = "h",
    mods = "CTRL|SHIFT",
    action = action.AdjustPaneSize({ "Left", 5 }),
  },
  {
    key = "l",
    mods = "CTRL|SHIFT",
    action = action.AdjustPaneSize({ "Right", 5 }),
  },
  {
    key = "j",
    mods = "CTRL|SHIFT",
    action = action.AdjustPaneSize({ "Down", 5 }),
  },
  {
    key = "k",
    mods = "CTRL|SHIFT",
    action = action.AdjustPaneSize({ "Up", 5 }),
  },
  {
    key = "m",
    mods = "LEADER",
    action = action.TogglePaneZoomState,
  },
  {
    key = "p",
    mods = "LEADER",
    action = action.ActivateTabRelative(-1),
  },
  {
    key = "n",
    mods = "LEADER",
    action = action.ActivateTabRelative(1),
  },
  {
    key = "l",
    mods = "LEADER",
    action = action.ActivateLastTab,
  },
  {
    key = "x",
    mods = "LEADER",
    action = action.CloseCurrentPane({ confirm = false }),
  },
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  {
    key = "LeftArrow",
    mods = "OPT",
    action = wezterm.action({ SendString = "\x1bb" }),
  },
  -- Make Option-Right equivalent to Alt-f; forward-word
  {
    key = "RightArrow",
    mods = "OPT",
    action = wezterm.action({ SendString = "\x1bf" }),
  },
}

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = action.ActivateTab(i - 1),
  })
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config_obj, hover, max_width)
  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end

  local index = tab.tab_index + 1

  -- Rosé Pine Colors
  local bg_active = "#c4a7e7" -- Iris
  local fg_active = "#191724" -- Base (dark text)
  local bg_inactive = "#26233a" -- Overlay
  local fg_inactive = "#908caa" -- Subtle
  local bg_hover = "#403d52" -- Highlight Med
  local fg_hover = "#e0def4" -- Text

  if tab.is_active then
    return {
      { Background = { Color = bg_active } },
      { Foreground = { Color = fg_active } },
      { Attribute = { Intensity = "Bold" } },
      { Attribute = { Italic = true } },
      { Text = " " .. index .. ": " .. title .. " " },
    }
  elseif hover then
    return {
      { Background = { Color = bg_hover } },
      { Foreground = { Color = fg_hover } },
      { Text = " " .. index .. ": " .. title .. " " },
    }
  else
    return {
      { Background = { Color = bg_inactive } },
      { Foreground = { Color = fg_inactive } },
      { Text = " " .. index .. ": " .. title .. " " },
    }
  end
end)

return config
