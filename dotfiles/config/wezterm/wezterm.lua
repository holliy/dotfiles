local wezterm = require 'wezterm'
local act = wezterm.action

wezterm.on('gui-startup', function(cmd)
    local cmd = cmd or {}
    cmd.height = 30
    cmd.width = 100

    wezterm.mux.spawn_window(cmd or {})
end)

local config = {
    --[[ font = wezterm.font {
        family="Fira Code Retina",
        harfbuzz_features={"calt=0", "clig=0", "liga=0"}
    } ]]
    font = wezterm.font_with_fallback {
        {
            family="Fira Code Retina",
            harfbuzz_features={"calt=0", "liga=0", "cv02", "cv05", "cv16", "ss01", "ss02", "ss03", "ss05"},
            stretch="Normal",
            scale=1.0,
        }, {
            family="Cica",
            scale=1.2,
            stretch="Normal"
        }
    },
    font_size = 10.8,
    line_height = 0.98,
    adjust_window_size_when_changing_font_size = false,
    use_resize_increments = true,
    use_ime = true,

    disable_default_key_bindings = true,
    -- disable_default_mouse_bindings = true,
    keys = {
        { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'PrimarySelection' },
        { key = 'Insert', mods = 'CTRL', action = act.CopyTo 'PrimarySelection' },
        { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
        { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
        { key = 'F2', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
        { key = 'l', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay },
        { key = 'n', mods = 'CTRL|SHIFT', action = act.SpawnWindow },
    },
    mouse_bindings = {
        {
            event = {Up = {streak = 1, button = 'Left'}},
            mods = 'NONE',
            action = act.CompleteSelection 'PrimarySelection'
        }, {
            event = {Up = {streak = 1, button = 'Left'}},
            mods = 'SHIFT',
            action = act.CompleteSelection 'PrimarySelection'
        }, {
            event = {Up = {streak = 1, button = 'Left'}},
            mods = 'CTRL',
            action = act.OpenLinkAtMouseCursor
        }
    },
    -- for modifyOtherKeys
    enable_csi_u_key_encoding = false,
    allow_win32_input_mode = false,

    use_fancy_tab_bar = false,
    window_background_opacity = 0.85,
    text_background_opacity = 0.6,

    window_padding = {
        left = "6px",
        right = "4px",
        top = "2px",
        bottom = "2px",
    }
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.default_prog = {"wsl.exe", "~", --[[ "-e", ]] "/bin/bash", "--login"}
    config.ssh_backend = "Ssh2"

    config.wsl_domains = wezterm.default_wsl_domains()
    config.default_domain = 'WSL:Ubuntu'
else
    config.default_prog = {"bash", "--login"}
end

return config
