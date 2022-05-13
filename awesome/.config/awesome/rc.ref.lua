-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local lain  = require("lain")
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
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local markup = lain.util.markup
-- Icon directory path
local icondir = "/home/gurpinder/.config/awesome/icons/"

awesome.set_preferred_icon_size(32)

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
beautiful.init("~/.config/awesome/themes~/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "code"
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

mymainmenu = awful.menu({ items = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        { "Terminal", terminal },
        { "VS Code", "code"}
    }
})

-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                      menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}


local inner_margin_left = 10
local inner_margin_right = 10
local inner_margin_top = 0
local inner_margin_bottom = 0
local outer_margin_left = 5
local outer_margin_right = 0
local outer_margin_top = 0
local outer_margin_bottom = 0

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget {
    format = '%a %b %d, %I:%M',
    widget = wibox.widget.textclock
}


local cpu = lain.widget.cpu({
    timeout = 2,
    settings = function()
        widget:set_markup("cpu " .. cpu_now.usage .. "%")
    end
})
local memory = lain.widget.mem({
    timeout = 2,
    settings = function()
        widget:set_markup("mem " .. mem_now.used .. "M")
    end
})


local cpu_widget = wibox.widget({
    {
        {
            widget = cpu.widget
        },
        left   = inner_margin_left,
        right  = inner_margin_right,
        top    = inner_margin_top,
        bottom = inner_margin_bottom,
        widget = wibox.container.margin
    },
    -- shape = function(cr, width, height)
    --     gears.shape.rounded_rect(cr, width, height, 5)
    -- end,
    bg = "#F4EEFF",
    fg="#131313",
    widget = wibox.container.background
})

local mem_widget = wibox.widget({
    {
        {
            widget = memory.widget
        },
        left   = inner_margin_left,
        right  = inner_margin_right,
        top    = inner_margin_top,
        bottom = inner_margin_bottom,
        widget = wibox.container.margin
    },
    -- shape = gears.shape.rounded_rect,
    bg = "#DCD6F7",
    fg="#131313",
    widget = wibox.container.background
})

local clock_widget = wibox.widget({
        {
            {
                widget = mytextclock
            },
            left   = inner_margin_left,
            right  = inner_margin_right,
            top    = inner_margin_top,
            bottom = inner_margin_bottom,
            widget = wibox.container.margin
        },
        -- shape = gears.shape.rounded_rect,
        bg = "#A6B1E1",
        fg="#131313",
        widget = wibox.container.background
})



wshape = function(radius)
    return function(cr, width, height)
        return gears.shape.rounded_rect(cr, width, height, 0)
    end
end

awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    -- awful.tag({ "1:WEB", "2:CODE", "3:TERM", "4:DB", "5:API", "6:MAIL" }, s, awful.layout.layouts[1])
    -- awful.tag({ "7:CHAT", "8:VM" }, s, awful.layout.layouts[2])
    -- awful.tag({ "9:SPOTIFY" }, s, awful.layout.layouts[2])
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Each screen has its own tag table.
    local names = {     "web", "code", "term",
                        "db", "api", "mail", 
                        "chat", "vm", "spotify" }
    local l = awful.layout.suit  -- Just to save some typing: use an alias.
    local layouts = {   l.tile, l.tile, l.tile, 
                        l.tile, l.tile, l.tile, 
                        l.floating, l.tile, l.tile }
    awful.tag(names, s, layouts)

    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    



    -- Create a taglist widget
    -- s.mytaglist = awful.widget.taglist {
    --     screen  = s,
    --     filter  = awful.widget.taglist.filter.all,
    --     buttons = taglist_buttons,
    -- }

    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        style   = {
            -- shape = wshape(5)
                
        },
        -- layout   = {
        --     spacing = -12,
        --     spacing_widget = {
        --         color  = '#dddddd',
        --         shape  = gears.shape.powerline,
        --         widget = wibox.widget.separator,
        --     },
        --     layout  = wibox.layout.fixed.horizontal
        -- },
        widget_template = {
            {
                {
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                -- top = 5,
                -- bottom = 5,
                left  = 5,
                right = 5,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
        buttons = taglist_buttons
    }
   
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style    = {
            -- shape_border_width = 1,
            -- shape_border_color = '#777777',
            shape = wshape(5)
        },
        layout   = {
            spacing = 10,
            -- spacing_widget = {
            --     {
            --         forced_width = 5,
            --         shape        = gears.shape.circle,
            --         widget       = wibox.widget.separator
            --     },
            --     valign = 'center',
            --     halign = 'center',
            --     widget = wibox.container.place,
            -- },
            layout  = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 5,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 2,
                right = 2,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }



    -- Create the wibox
    -- s.mywibox = awful.wibox({ 
    --     position = "top", 
    --     screen = s,
    --     height = 38,
    --     bg = beautiful.bg_normal .. "00",
    --     -- shape = function(cr, width, height)
    --     --     gears.shape.rounded_rect(cr, width, height, 5)
    --     -- end,
    -- })
    -- s.mywibox.widget = {
    --     widget = wibox.container.background,
    --     shape_border_width = 12,
   
    -- }

    local r_background = "#000000"
    local r_right = 0
    local r_left = 4
    local r_top = 3
    local r_bottom = 3

    -- Add widgets to the wibox
    -- s.mywibox:setup {
    --     {
    --         layout = wibox.layout.align.horizontal,
    --         { -- Left widgets
    --             layout = wibox.layout.fixed.horizontal,
    --             -- mylauncher,
    --            {
    --                 {

    --                     {
    --                         widget = s.mytaglist
    --                     },
    --                     right  = 3,
    --                     left   = 3,
    --                     top    = 3,
    --                     bottom = 3,
    --                     widget = wibox.container.margin
    --                 },
    --                 shape = wshape(5),
    --                 bg = "#000000",
    --                 widget = wibox.container.background
    --             },
    --             -- s.mytaglist,
    --             -- s.mypromptbox,
    --         },
    --         {
    --             {
                    
    --                 widget = s.mytasklist, -- Middle widget
    --             },
    --             left = 200, 
    --             right = 200,
    --             widget = wibox.container.margin
    --         },
    --         { -- Right widgets
    --             layout = wibox.layout.fixed.horizontal,
    --             style = {
    --                 shape = wshape(5)
    --             },
    --             {
    --                 {
    --                     mem_widget,  
    --                     right  = r_right,
    --                     left   = r_left,
    --                     top    = r_top,
    --                     bottom = r_bottom,
    --                     widget = wibox.container.margin
    --                 },
    --                 bg = r_background,
    --                 widget = wibox.container.background
    --             } ,
    --             {
    --                 {
    --                     cpu_widget,  
    --                     right  = r_right,
    --                     left   = r_left,
    --                     top    = r_top,
    --                     bottom = r_bottom,
    --                     widget = wibox.container.margin
    --                 },
    --                 bg = r_background,
    --                 widget = wibox.container.background
    --             } ,
    --             {
    --                 {
    --                     clock_widget,  
    --                     right  = r_right,
    --                     left   = r_left,
    --                     top    = r_top,
    --                     bottom = r_bottom,
    --                     widget = wibox.container.margin
    --                 },
    --                 bg = r_background,
    --                 widget = wibox.container.background
    --             } ,
               
    --             {
    --                 {
    --                     {

    --                         {
    --                             {
    --                                 widget = wibox.widget.systray
    --                             },
    --                             top = 5,
    --                             bottom = 5,
    --                             left = 5,
    --                             right = 5,
    --                             widget = wibox.container.margin
    --                         },
    --                         bg = beautiful.bg_systray,
    --                         widget = wibox.container.background 
    --                     },
    --                     right  = r_right,
    --                     left   = r_left,
    --                     top    = r_top,
    --                     bottom = r_bottom,
    --                     widget = wibox.container.margin
    --                 },
    --                 bg = r_background,
    --                 widget = wibox.container.background
    --             } ,
    --             {
    --                 {
    --                     s.mylayoutbox,  
    --                     right  = 2,
    --                     left   = 2,
    --                     top    = r_top,
    --                     bottom = r_bottom,
    --                     widget = wibox.container.margin
    --                 },
    --                 bg = r_background,
    --                 widget = wibox.container.background
    --             } ,
                
    --         },
    --     },
    --     top= 5,
    --     left=5,
    --     right=5,
    --     bottom=0,
    --     color = "#000000" .. "00",
    --     widget = wibox.container.margin
    -- }

    s.mytaglist2 = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all
    }
    s.mytasklist2 = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- test
    s.workspacesBox = awful.wibox({
        position = "top",
        screen = s,
        width = "98%",
        height = "32"
        -- border_width  = 5,
        -- border_color = "#000000" .. "00",
        -- bg = "#ffffff",
        -- fg = "#131313",
    })

    s.workspacesBox : setup {
        {
            {
                {
                    s.mytaglist2,
                    layout = wibox.layout.fixed.horizontal
                },
                -- bg = "#ffffff",
                -- fg = "#131313",
                widget = wibox.container.background,
            },
            {
                {
                    {
                        s.mytasklist2,
                        -- spacing = 50,
                        layout = wibox.layout.flex.horizontal
                    },
                    left = 300,
                    right = 300,
                    widget = wibox.container.margin
                },
                -- bg = "#999999",
                -- fg = "#131313",
                widget = wibox.container.background,
            },
            {
                {
                    
                    {
                        {
                            {
                                widget = wibox.widget.systray
                            },
                            margins = 2,
                            widget = wibox.container.margin
                        },
                        layout = wibox.layout.fixed.horizontal,
                       
                    },
                   
                    cpu_widget,
                    mem_widget,
                    clock_widget,
                    s.mylayoutbox,
                    spacing = 2,
                    layout = wibox.layout.fixed.horizontal
                },
                -- bg = "#ffffff",q
                -- fg = "#131313",
                widget = wibox.container.background,
            },
            layout = wibox.layout.align.horizontal
        },
        top = 0,
        left = 0,
        right = 0,
        bottom = 0,
        widget = wibox.container.margin
    }

  

end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
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
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

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
    awful.key({ modkey }, "d", function() awful.util.spawn("rofi -show drun") end,
    {description = "show rofi", group = "launcher"}),
    awful.key({ modkey , "Shift"}, "Delete", function() awful.util.spawn("rofi -show power-menu -modi power-menu:~/.config/rofi/rofi-power-menu") end,
    {description = "show rofi", group = "launcher"}),
    awful.key({ modkey , "Shift"}, "d", function() awful.util.spawn("rofi -show ssh") end,
        {description = "show rofi", group = "launcher"}),
    awful.key({ modkey , "Shift"}, "c", function() awful.util.spawn("rofi -show calc -modi calc -no-show-match -no-sort") end,
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
    awful.key({ modkey }, "n", function() awful.util.spawn("pcmanfm") end,
    {description = "file manager", group = "launcher"}),
    awful.key({ modkey }, "semicolon", function() awful.util.spawn("code") end,
    {description = "code", group = "launcher"})
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

    -- Spawn floating clients centered
    { rule_any = { type = { "dialog" }  },
        properties = {
            placement = awful.placement.centered
        }
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    { rule = { class = "Brave-browser" },
      properties = { screen = 1, tag = "web" } },
    { rule = { class = "firefox" },
      properties = { screen = 1, tag = "web" } },
    { rule = { class = "Code" },
      properties = { screen = 1, tag = "code" } },
    { rule = { class = "MongoDB Compass" },
      properties = { screen = 1, tag = "db" } },
    { rule = { class = "Studio 3T" },
      properties = { screen = 1, tag = "db" } },
    { rule = { class = "Insomnia" },
      properties = { screen = 1, tag = "api" } },
    { rule = { class = "Mailspring" },
      properties = { screen = 1, tag = "mail" } },
    { rule = { class = "zoom " },
      properties = { screen = 1, tag = "chat" } },
    { rule = { class = "Virt-manager" },
      properties = { screen = 1, tag = "vm" } },
    
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

client.connect_signal("property::class", function(c)
    if c.class == "Spotify" then
       c:move_to_tag(screen[1].tags[9])
    --    local tag = awful.tag.gettags(2)[3]
    --    if tag then
    --      awful.tag.viewonly(tag)
    --    end
    end
 end)


-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}