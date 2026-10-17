-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                     Defaults Configuration                  ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local defaults = {
    filemanager = "nautilus",
    terminal    = "kitty",
    applauncher = "rofi -show combi -modi window,drun,combi -combi-modi drun,window",
    idlehandler = "hypridle",
    capturing   = 'grim -g "$(slurp)" - | swappy -f -',
    browser     = "helium-browser",
    editor      = "code",
}

return {
    defaults = defaults,
}
