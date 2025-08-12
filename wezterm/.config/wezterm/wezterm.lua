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
-- config.show_tab_index_in_tab_bar = false

config.term = "xterm-256color"
config.max_fps = 200

config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.font_size = 16
config.window_frame = {
  font_size = 14.0,
}
config.color_scheme = "Catppuccin Macchiato"
config.window_background_opacity = 1
-- config.window_decorations = "RESIZE"
config.default_workspace = "main"

-- config.enable_tab_bar = false

-- Dim inactive panes
--
config.inactive_pane_hsb = {
  saturation = 1,
  brightness = 0.7,
}

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

config.window_background_image = init_bg

config.window_background_image_hsb = {
  -- Darken the background image by reducing it
  brightness = 0.05,
  hue = 1.0,
  saturation = 0.8,
}
-- End image background settings

local direction_keys = {
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function split_nav(key)
  return {
    mods = "LEADER",
    key = key,
    action = wezterm.action.ActivatePaneDirection(direction_keys[key])
  }
end

-- Keys
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  -- Double Ctrl-a to send Ctrl-a
  { key = "q", mods = "LEADER|CTRL", action = action.SendKey({ key = "a", mods = "CTRL" }) },
  -- Change the tab title name
  {
    key = "E",
    mods = "CTRL|SHIFT",
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
          window_background_image = new_background,
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
  { key = "x", mods = "LEADER",      action = action.CloseCurrentPane({ confirm = false }) },
}

-- for i = 1, 9 do
-- 	table.insert(config.keys, {
-- 		key = tostring(i),
-- 		mods = "LEADER",
-- 		action = action.ActivateTab(i - 1),
-- 	})
-- end

return config
