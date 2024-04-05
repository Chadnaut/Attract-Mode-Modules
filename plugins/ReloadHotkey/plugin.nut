/*################################################
# Reload hotkey
#
# Reload layout when custom key pressed
# Version 0.1.0
# Chadnaut 2024
# https://github.com/Chadnaut/Attract-Mode-Modules
#
################################################*/

class UserConfig</ help="Reload layout when custom key pressed (v0.1)" /> {
    </  label="Hotkey",
        options="Custom1,Custom2,Custom3,Custom4,Custom5,Custom6",
        help="Key to reload the layout",
        order=1 />
    reload_signal="Custom1"
}

class ReloadHotkey {

    reload_signal = null;

    constructor() {
        local config = fe.get_config();
        reload_signal = config["reload_signal"].tolower();
        fe.add_signal_handler(this, "on_signal");
    }

    function on_signal(signal) {
        if (signal == reload_signal) fe.signal("reload");
    }
}

fe.plugin["ReloadHotkey"] <- ReloadHotkey();
