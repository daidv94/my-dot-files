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

-- Keys
config.keys = {
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
}

return config
