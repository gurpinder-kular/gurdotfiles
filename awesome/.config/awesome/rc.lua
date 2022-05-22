-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local os = os
local lain = require("lain")
local markup = lain.util.markup

local HOMEDIR = os.getenv("HOME")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/themes/gur/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "Awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Ranger", terminal .. " -e ranger" },
                                    { "Terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

local workflow_widget = wibox.widget {
    text = "Workflow",
    widget = wibox.widget.textbox
}

local workspace_apps = function()
    awful.spawn.single_instance("brave")
    awful.spawn.single_instance("code")
    -- awful.spawn.single_instance("terminal")
    awful.spawn.single_instance("mongodb-compass")
    awful.spawn.single_instance("insomnia")
    awful.spawn.single_instance("mailspring")
    awful.spawn.single_instance("zoom")
    awful.spawn.single_instance("bitwarden-desktop")
end

workflow_widget:connect_signal("button::press",
    workspace_apps
)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local spotify = {
    icon = "\u{f1bc}"
}

corder_radius = function(radius)
    return function(cr, width, height)
        return gears.shape.rounded_rect(cr, width, height, radius)
    end
end

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget {
    format = ' <span> %a %b %d, %I:%M </span> ',
    widget = wibox.widget.textclock
}

-- TIME
local clockicon = wibox.widget{
    markup = ' \u{f017} ',
    widget = wibox.widget.textbox
}
clockicon.font = beautiful.icon_font .. beautiful.icon_size
clockwidget = wibox.widget {
    format = '<span> %I:%M </span>',
    widget = wibox.widget.textclock
}

-- CALENDAR
local calendaricon = wibox.widget{
    markup = ' \u{f073} ',
    widget = wibox.widget.textbox
}
calendaricon.font = beautiful.icon_font .. beautiful.icon_size
calendarwidget = wibox.widget {
    format = '<span> %a %b %d </span>',
    widget = wibox.widget.textclock
}

-- CPU
local cpuicon = wibox.widget{
    markup = ' \u{f2db} ',
    widget = wibox.widget.textbox
}
cpuicon.font = beautiful.icon_font .. beautiful.icon_size
local cpuwidget = lain.widget.cpu({
    settings = function()
        widget:set_markup(" " .. cpu_now.usage .. "% ")
    end
})

-- Memory
local memoryicon = wibox.widget{
    markup = ' \u{f2db} ',
    widget = wibox.widget.textbox
}
memoryicon.font = beautiful.icon_font .. beautiful.icon_size
local memorywidget= lain.widget.mem({
    settings = function()
        widget:set_markup(" " .. mem_now.used .. "M ")
    end
})

-- Net
local netdownicon = wibox.widget{
    markup = ' \u{f019} ',
    widget = wibox.widget.textbox
}
netdownicon.font = beautiful.icon_font .. beautiful.icon_size
local netdowninfo = wibox.widget.textbox()

local netupicon = wibox.widget{
    markup = ' \u{f093} ',
    widget = wibox.widget.textbox
}
netupicon.font = beautiful.icon_font .. beautiful.icon_size
local netupinfo = lain.widget.net({
    settings = function()
        widget:set_markup(" " .. net_now.sent .. " ")
        netdowninfo:set_markup(" " .. net_now.received .. " ")
    end
})

local hlayout = wibox.layout.flex.horizontal();
hlayout:set_max_widget_size(150)

local rangerwidget = wibox.widget({
    image  = HOMEDIR .. "/gurdotfiles/ranger.png",
    resize = true,
    widget = wibox.widget.imagebox
})
rangerwidget:connect_signal("button::press", function() awful.spawn(terminal .. " -e ranger" ) end)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    --set_wallpaper(s)

    -- Each screen has its own tag table.P
    local names =   {   "WEB", "CODE", "TERM",
                        "DB", "API", "MAIL", 
                        "CHAT", "PWD", "MEDIA" , 
                        --"\u{e007}" 
                    }
    local l = awful.layout.suit  -- Just to save some typing: use an alias.
    local layouts = {   l.tile, l.tile, l.tile, 
                        l.tile, l.tile, l.tile, 
                        l.floating, l.tile, l.tile }
    awful.tag(names, s, layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout   = {
            spacing = 0,
            -- forced_width = 10,
            layout  = hlayout  -- wibox.layout.flex.horizontal
        },
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        widget = wibox.container.margin,
        margins = beautiful.wibar_margin,
        {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                --mylauncher,
                {
                    rangerwidget,
                    right = 5,
                    widget = wibox.container.margin
                },
                s.mytaglist,
                s.mypromptbox,
            },
            {
                s.mytasklist, -- Middle widget
                left = 10,
                -- right = 100,
                widget = wibox.container.margin
            },
       
            { -- Right widgets
                {   
                    layout = wibox.layout.fixed.horizontal,
                    --mykeyboardlayout,
                    -- workflow_widget,
                
                    -- network upload
                    {
                        
                        {
                            {
                                netupicon,
                                bg = "#1F1D36",
                                fg = "#ffffff",
                                shape = corder_radius(0),
                                widget = wibox.container.background
                            },
                            {
                                netupinfo.widget,
                                bg = "#3F3351",
                                fg = "#ffffff",
                                shape = corder_radius(0),
                                widget = wibox.container.background
                            },
                            layout = wibox.layout.fixed.horizontal
                        },
                        left = 5,
                        right = 5,
                        widget = wibox.container.margin
                    },

                    -- network download
                    {
                        
                        {
                            {
                                netdownicon,
                                bg = "#1F1D36",
                                fg = "#ffffff",
                                shape = corder_radius(0),
                                widget = wibox.container.background
                            },
                            {
                                netdowninfo,
                                bg = "#3F3351",
                                fg = "#ffffff",
                                shape = corder_radius(0),
                                widget = wibox.container.background
                            },
                            layout = wibox.layout.fixed.horizontal
                        },
                        -- left = 5,
                        right = 5,
                        widget = wibox.container.margin
                    },

                    -- memory
                    {
                        
                        {
                            {
                                memoryicon,
                                bg = "#F7A440",
                                fg = "#131313",
                                shape = corder_radius(0),
                                widget = wibox.container.background
                            },
                            {
                                memorywidget,
                                bg = "#FFC288",
                                fg = "#131313",
                                shape = corder_radius(0),
                                widget = wibox.container.background
                            },
                            layout = wibox.layout.fixed.horizontal
                        },
                        -- left = 5,
                        right = 5,
                        widget = wibox.container.margin
                    },
                    -- cpu
                    {
                        
                        {
                            {
                                cpuicon,
                                bg = "#BE9FE1",
                                fg = "#131313",
                                shape = corder_radius(0),
                                widget = wibox.container.background
                            },
                            {
                                cpuwidget,
                                bg = "#C9B6E4",
                                fg = "#131313",
                                shape = corder_radius(0),
                                widget = wibox.container.background
                            },
                            layout = wibox.layout.fixed.horizontal
                        },
                        -- left = 5,
                        right = 5,
                        widget = wibox.container.margin
                    },
                    -- calendar
                    {
                        
                        {
                            {
                                calendaricon,
                                bg = "#764AF1",
                                fg = "#131313",
                                shape = corder_radius(0),
                                widget = wibox.container.background
                            },
                            {
                                calendarwidget,
                                bg = "#9772FB",
                                fg = "#131313",
                                shape = corder_radius(0),
                                widget = wibox.container.background
                            },
                            layout = wibox.layout.fixed.horizontal
                        },
                        -- left = 5,
                        right = 5,
                        widget = wibox.container.margin
                    },
                    -- clock
                    {
                        
                        {
                            {
                                clockicon,
                                bg = "#34BE82",
                                fg = "#131313",
                                shape = corder_radius(0),
                                widget = wibox.container.background
                            },
                            {
                                clockwidget,
                                bg = "#2FDD92",
                                fg = "#131313",
                                shape = corder_radius(0),
                                widget = wibox.container.background
                            },
                            layout = wibox.layout.fixed.horizontal
                        },
                        -- left = 5,
                        right = 5,
                        widget = wibox.container.margin
                    },
                    -- system tray
                    {
                        {
                            widget = wibox.widget.systray
                        },
                        right = 5,
                        widget = wibox.container.margin
                    },
                    s.mylayoutbox,
                },
                -- bottom = 4,
                widget = wibox.container.margin
            },
        }
        
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
    -- awful.button({ }, 4, awful.tag.viewnext),
    -- awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,    "Shift"       }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
   
    -- awful.key({ modkey,           }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end,
    --     {description = "go back", group = "client"}),

    -- awful.key({ modkey }, "h", function()
    --     awful.client.focus.bydirection("left")
    --     if client.focus then client.focus:raise() end
    -- end),
    -- awful.key({ modkey }, "j", function()
    --     awful.client.focus.bydirection("down")
    --     if client.focus then client.focus:raise() end
    -- end),
    -- awful.key({ modkey }, "k", function()
    --     awful.client.focus.bydirection("up")
    --     if client.focus then client.focus:raise() end
    -- end),
    -- awful.key({ modkey }, "l", function()
    --     awful.client.focus.bydirection("right")
    --     if client.focus then client.focus:raise() end
    -- end),


    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,     "Shift"      }, "Return", function () awful.spawn(terminal .. " -e ranger") end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Control"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "Down",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    -- awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
    --           {description = "run prompt", group = "launcher"}),

    -- awful.key({ modkey }, "x",
    --           function ()
    --               awful.prompt.run {
    --                 prompt       = "Run Lua code: ",
    --                 textbox      = awful.screen.focused().mypromptbox.widget,
    --                 exe_callback = awful.util.eval,
    --                 history_path = awful.util.get_cache_dir() .. "/history_eval"
    --               }
    --           end,
    --           {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    --   rofi
    awful.key({ modkey,           }, "Tab",
        function ()
        awful.spawn("rofi -show window -show-icons")
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey }, "d", function() awful.util.spawn("rofi -show drun -show-icons") end,
    {description = "show rofi", group = "launcher"}),
    awful.key({ modkey , "Shift"}, "Delete", function() awful.util.spawn("rofi -show power-menu -modi power-menu:~/.config/rofi/rofi-power-menu") end,
    {description = "show rofi", group = "launcher"}),
    awful.key({ modkey , "Shift"}, "d", function() awful.util.spawn("rofi -show ssh") end,
        {description = "show rofi", group = "launcher"}),
    awful.key({ modkey , "Shift"}, "c", function() awful.util.spawn("rofi -show calc -modi calc -no-show-match -no-sort -no-bold -no-history -hint-result '' -hint-welcome ''") end,
        {description = "show rofi", group = "launcher"}),
    awful.key({ modkey , "Shift"}, "e", function() awful.util.spawn("rofi -show emoji -modi emoji") end,
        {description = "show rofi", group = "launcher"}),
    -- media keys
    awful.key({}, "XF86AudioRaiseVolume", function() awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5000") end),
    awful.key({}, "XF86AudioLowerVolume", function() awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5000") end),
    awful.key({}, "XF86AudioMute", function() awful.util.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle") end),
    awful.key({}, "XF86AudioPlay", function() awful.util.spawn("playerctl play-pause") end),
    awful.key({}, "XF86AudioPrev", function() awful.util.spawn("playerctl previous") end),
    awful.key({}, "XF86AudioNext", function() awful.util.spawn("playerctl next") end),

    -- programs
    awful.key({ modkey }, "w", function() awful.util.spawn("brave") end,
    {description = "browser", group = "launcher"}),
    awful.key({ modkey }, "n", function() awful.util.spawn("pcmanfm-qt") end,
    {description = "file manager", group = "launcher"}),
    awful.key({ modkey }, "semicolon", function() awful.util.spawn("code") end,
    {description = "code", group = "launcher"}),
    awful.key({ modkey }, "Print", function() awful.util.spawn("flameshot gui") end,
    {description = "screenshot", group = "launcher"}),
    awful.key({ modkey , "Shift" }, "Print", function() awful.util.spawn("flameshot full") end,
    {description = "screenshot", group = "launcher"}),
    -- workspace apps 
    awful.key({ modkey , "Ctrl",   "Shift" }, "Return", workspace_apps,
    {description = "screenshot", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "Down",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.






for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                        local t = awful.screen.focused().selected_tag
                        -- if t then
                        --     t.name = '[' .. t.name .. ']'
                        -- end
                        if file_exists("/home/gurpinder/.config/awesome/walls/" .. i .. ".jpg") then
                            awful.util.spawn("feh --bg-fill /home/gurpinder/.config/awesome/walls/" .. i .. ".jpg")
                        end
                        
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

local Alt = "Mod1"
-- extra tags
-- for i = 10, 18 do
--     globalkeys = gears.table.join(globalkeys,
--         awful.key({ modkey, Alt }, i - 9, function () 
--             local screen = awful.screen.focused()
--             local tag = screen.tags[i]
--             if tag then
--                tag:view_only()
--             end
--         end,
--     {description = "show main menu", group = "awesome"}) 
-- )
-- end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
 		  "gnome-calculator",
          "Lxappearance",
          "Nitrogen",
          "Pavucontrol",
          "Blueberry.py",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

	-- Spawn floating clients centered
    { rule_any = { type = { "dialog" }  },
        properties = {
            placement = awful.placement.centered
        }
    },

	-- App rules
    { rule = { class = "Brave-browser" },
      properties = { screen = 1, tag = "WEB" } },
    { rule = { class = "firefox" },
      properties = { screen = 1, tag = "WEB" } },
    { rule = { class = "Code" },
      properties = { screen = 1, tag = "CODE" } },
    { rule = { class = "MongoDB Compass" },
      properties = { screen = 1, tag = "DB" } },
    { rule = { class = "Studio 3T" },
      properties = { screen = 1, tag = "DB" } },
    { rule = { class = "Insomnia" },
      properties = { screen = 1, tag = "API" } },
    { rule = { class = "Mailspring" },
      properties = { screen = 1, tag = "MAIL" } },
    { rule = { class = "zoom " },
      properties = { screen = 1, tag = "CHAT" } },
    { rule = { class = "Bitwarden" },
      properties = { screen = 1, tag = "PWD" } },
    { rule = { class = "Spotify" },
      properties = { screen = 1, tag = "MEDIA" } },
    { rule = { class = "Gimp-2.10" },
      properties = { screen = 1, tag = "MEDIA" } },
    { rule = { class = "obs" },
      properties = { screen = 1, tag = "MEDIA" } },
    { rule = { class = "Shotcut" },
      properties = { screen = 1, tag = "MEDIA" } },
     
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


client.connect_signal("property::class", function(c)
    if c.class == "Spotify" then
       c:move_to_tag(screen[1].tags[9])
    --    local tag = awful.tag.gettags(2)[3]
    --    if tag then
    --      awful.tag.viewonly(tag)
    --    end
    end
 end)


-- start programs
autostart = false
autostartApps = {
	--"nm-applet",
	--"volumeicon"
}
if autostart then
	for app = 1, #autostartApps do 
		awful.util.spawn(autostartApps[app])
	end
end

