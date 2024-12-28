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

config.term = "xterm-256color"

config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.font_size = 15
config.window_frame = {
	font_size = 14.0,
}
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 1
config.window_decorations = "RESIZE"
config.default_workspace = "main"

-- Enable this config if I want to switch back to tmux
-- config.enable_tab_bar = false

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.24,
	brightness = 0.5,
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
	saturation = 0.7,
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
		key = key,
		mods = "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if pane:get_user_vars().IS_NVIM == "true" then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = "CTRL" },
				}, pane)
			else
				win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
			end
		end),
	}
end

-- Keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Double Ctrl-a to send Ctrl-a
	{ key = "a", mods = "LEADER|CTRL", action = action.SendKey({ key = "a", mods = "CTRL" }) },
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
	-- move between split panes
	split_nav("h"),
	split_nav("j"),
	split_nav("k"),
	split_nav("l"),
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
		key = "c",
		mods = "LEADER",
		action = action.SpawnTab("CurrentPaneDomain"),
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
	{ key = "x", mods = "LEADER", action = action.CloseCurrentPane({ confirm = true }) },
}

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = action.ActivateTab(i - 1),
	})
end

return config
