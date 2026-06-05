-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                     Defaults Configuration                  ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local home = os.getenv("HOME")

local defaults = {
    filemanager = "nautilus",
    terminal    = "kitty",
    applauncher = "rofi -show combi -modi window,drun,combi -combi-modi drun,window",
    idlehandler = "hypridle",
    capturing   = 'grim -g "$(slurp)" - | swappy -f -',
    browser     = "helium-browser",
    editor      = "code",
    launch      = home .. "/.config/hypr/scripts/app_launcher.sh",
    player      = home .. "/.config/hypr/scripts/player.sh",
}

return {
    defaults = defaults,
}
