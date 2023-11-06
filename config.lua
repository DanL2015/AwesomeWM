-- User specific config here
local M = {}

M.modkey = "Mod4"

M.apps =  {
    terminal = "alacritty",
    editor = "nvim",
    browser = "firefox",
    file_manager = "nemo",
    volume_manager = "pavucontrol",
    network_manager = "nm-connection-editor",
    power_manager = "xfce4-power-manager-settings",
    bluetooth_manager = "blueman-manager",
    settings = "xfce4-settings-manager",
}

M.editor_cmd = M.apps.terminal.." -e "..M.apps.editor

return M
