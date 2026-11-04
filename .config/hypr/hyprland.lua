-- Hyprland 0.57+ Lua configuration
-- Converted from the supplied hyprland.conf.
-- Place at: ~/.config/hypr/hyprland.lua
--
-- This uses Hyprland's native Lua API. A few legacy settings that do not
-- have a direct 1:1 Lua equivalent are called out in comments below.

-- ============================================================================
-- Programs
-- ============================================================================

local terminal = "ghostty"
local browser = "qutebrowser"
local passwordManager = "keepassxc"

-- Keep these variables available for future modules / edits.
-- (fileManager, steam, menu and menuWindow are currently not bound.)

-- ============================================================================
-- Environment
-- ============================================================================

hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GL_GSYNC_ALLOWED", "0")
hl.env("__GL_VRR_ALLOWED", "0")

-- ============================================================================
-- Monitor
-- ============================================================================

hl.monitor({
	output = "DP-2",
	mode = "3840x1600@144",
	position = "0x0",
	scale = 1,
})

-- ============================================================================
-- General appearance and layout
-- ============================================================================

hl.config({
	general = {
		gaps_in = 10,
		gaps_out = 15,
		border_size = 2,
		["col.active_border"] = "rgba(2aa198ee)",
		["col.inactive_border"] = "rgba(586e75aa)",
		resize_on_border = false,
		allow_tearing = false,
		layout = "master",
	},

	cursor = {
		no_hardware_cursors = false,
	},

	decoration = {
		rounding = 5,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		fullscreen_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	master = {
		new_status = "slave",
		orientation = "right",
		mfact = 0.50,
		-- always_center_master was commented out in the original config.
	},

	misc = {
		force_default_wallpaper = 1,
		disable_hyprland_logo = true,
	},

	input = {
		kb_layout = "us",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
		},
	},
})

-- Original per-device rule:
--   device { name = epic-mouse-v1; sensitivity = -0.5 }
-- Left out of the main input table because device-specific configuration
-- uses a separate API/schema in the Lua config. Check `hyprctl devices`
-- and the current Hyprland Lua stubs before adding it.

-- ============================================================================
-- Animations
-- ============================================================================

hl.curve("wind", {
	type = "bezier",
	points = { { 0.05, 0.9 }, { 0.1, 1.05 } },
})

hl.curve("winIn", {
	type = "bezier",
	points = { { 0.1, 1.1 }, { 0.1, 1.1 } },
})

hl.curve("winOut", {
	type = "bezier",
	points = { { 0.3, -0.3 }, { 0, 1 } },
})

hl.curve("linear", {
	type = "bezier",
	points = { { 1, 1 }, { 1, 1 } },
})

hl.curve("Cubic", {
	type = "bezier",
	points = { { 0.1, 0.1 }, { 0.1, 1 } },
})

hl.curve("overshot", {
	type = "bezier",
	points = { { 0.05, 0.9 }, { 0.1, 1.1 } },
})

hl.curve("ease-in-out", {
	type = "bezier",
	points = { { 0.17, 0.67 }, { 0.83, 0.67 } },
})

hl.curve("ease-in", {
	type = "bezier",
	points = { { 0.17, 0.67 }, { 0.83, 0.67 } },
})

hl.curve("ease-out", {
	type = "bezier",
	points = { { 0.42, 0 }, { 1, 1 } },
})

hl.curve("easeInOutSine", {
	type = "bezier",
	points = { { 0.37, 0 }, { 0.63, 1 } },
})

hl.curve("easeInSine", {
	type = "bezier",
	points = { { 0.12, 0 }, { 0.39, 0 } },
})

hl.curve("easeOutSine", {
	type = "bezier",
	points = { { 0.61, 1 }, { 0.88, 1 } },
})

-- Hyprland's Lua animation speed is expressed in deciseconds.
-- The old config used speed 3 (300 ms), which is retained here.
hl.animation({
	leaf = "windowsIn",
	enabled = true,
	speed = 3,
	bezier = "easeInOutSine",
	style = "popin",
})

hl.animation({
	leaf = "windowsOut",
	enabled = true,
	speed = 3,
	bezier = "easeInOutSine",
	style = "popin",
})

hl.animation({
	leaf = "border",
	enabled = true,
	speed = 3,
	bezier = "easeInOutSine",
})

hl.animation({
	leaf = "borderangle",
	enabled = true,
	speed = 30,
	bezier = "easeInOutSine",
	style = "loop",
})

hl.animation({
	leaf = "workspacesIn",
	enabled = true,
	speed = 3,
	bezier = "easeInOutSine",
	style = "slidefade",
})

hl.animation({
	leaf = "workspacesOut",
	enabled = true,
	speed = 3,
	bezier = "easeInOutSine",
	style = "slidefade",
})

hl.animation({
	leaf = "specialWorkspaceIn",
	enabled = true,
	speed = 3,
	bezier = "easeInOutSine",
	style = "slidevert",
})

hl.animation({
	leaf = "specialWorkspaceOut",
	enabled = true,
	speed = 3,
	bezier = "easeInOutSine",
	style = "slidevert",
})

hl.animation({
	leaf = "layersIn",
	enabled = true,
	speed = 3,
	bezier = "easeInOutSine",
	style = "fade",
})

hl.animation({
	leaf = "layersOut",
	enabled = true,
	speed = 3,
	bezier = "easeInOutSine",
	style = "fade",
})

-- ============================================================================
-- Workspaces and window rules
-- ============================================================================

hl.workspace_rule({
	workspace = "1",
	persistent = true,
})

hl.window_rule({
	name = "discord-workspace-2",
	match = {
		class = "discord",
	},
	workspace = "2",
})

hl.window_rule({
	name = "spotify-scratchpad",
	match = {
		class = "^(Spotify|spotify)$",
	},
	workspace = "special:spotify",
})

hl.window_rule({
	name = "discord-scratchpad",
	match = {
		class = "^(Discord|discord)$",
	},
	workspace = "special:spotify",
})

hl.window_rule({
	name = "fullscreen_opacity",
	match = {
		class = ".*",
		fullscreen = true,
	},
	opacity = "1.0 override 1.0 override 1.0 override",
})

-- NOTE: The original config has TWO rules matching Discord:
-- one sends it to workspace 2 and another sends it to special:spotify.
-- Both are retained verbatim; because both match, the later rule may
-- override the earlier one. Remove one if that was not intentional.

-- ============================================================================
-- Autostart
-- ============================================================================

hl.on("hyprland.start", function()
	-- Preserve the original 2-second delay before these commands.
	hl.exec_cmd("sleep 2 && hyprm reload -n")
	hl.exec_cmd("sleep 2 && waybar")

	hl.exec_cmd("vicinae server")
	hl.exec_cmd(terminal)
	hl.exec_cmd("discord")
	-- hl.exec_cmd("spotify")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("copyq")
	hl.exec_cmd("./test.sh")
end)

-- ============================================================================
-- Keybindings
-- ============================================================================

local mod = "SUPER"

-- Applications
hl.bind(mod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + U", hl.dsp.exec_cmd(passwordManager))
hl.bind(mod .. " + P", hl.dsp.exec_cmd("pulsemixer"))
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("vicinae toggle"))

-- Window management
hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + M", hl.dsp.exit())
hl.bind(mod .. " + V", hl.dsp.window.float())
hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.window.float())
-- Original `fullscreen, 1` = maximized (keeps gaps / bar).
hl.bind(
	mod .. " + F",
	hl.dsp.window.fullscreen({
		action = "set",
		mode = "maximized",
	})
)
-- Original `fullscreen, 0` = true fullscreen.
hl.bind(
	mod .. " + SHIFT + F",
	hl.dsp.window.fullscreen({
		action = "set",
		mode = "fullscreen",
	})
)

-- Float + pin helper script
hl.bind(mod .. " + I", hl.dsp.exec_cmd("~/.config/hypr/pin-float.sh"))

-- Focus movement
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))

-- Screenshots
hl.bind(mod .. " + P", hl.dsp.exec_cmd("grimblast save active"))
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("grimblast save area"))
hl.bind(mod .. " + ALT + P", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
hl.bind(mod .. " + CTRL + P", hl.dsp.exec_cmd("grimblast save screen"))

-- Workspace switching
for i = 1, 10 do
	local key = i % 10 -- Workspace 10 uses key 0
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Move active window in the layout
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

hl.bind(mod .. " + SHIFT + LEFT", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + DOWN", hl.dsp.window.move({ direction = "d" }))
hl.bind(mod .. " + SHIFT + UP", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + RIGHT", hl.dsp.window.move({ direction = "r" }))

-- Special workspaces / scratchpads
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace special:magic"))

hl.bind(mod .. " + A", hl.dsp.workspace.toggle_special("spotify"))
hl.bind(mod .. " + SHIFT + A", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace special:spotify"))

-- Media controls
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))

-- Fallback media controls
hl.bind(mod .. " + F9", hl.dsp.exec_cmd("playerctl previous"))
hl.bind(mod .. " + F10", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind(mod .. " + F11", hl.dsp.exec_cmd("playerctl next"))

-- Mouse: move with SUPER + left button; resize with SUPER + right button.
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
