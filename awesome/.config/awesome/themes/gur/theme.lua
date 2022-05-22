---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local os = os
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.confdir = os.getenv("HOME") .. "/.config/awesome/themes~/"

theme.systray_icon_spacing = 5
theme.notification_icon_size = 48

-- theme.font          = "Fira Sans Compressed 11"
-- theme.font          = "Input Mono 11"
-- theme.font          = "Input Mono Compressed 11"
theme.font          = "Recursive Sn Lnr St 11"
--theme.font          = "Rec Mono linear 11"

theme.icon_size = 14
theme.icon_font = "Font Awesome 6 Free " -- attention to space at the end!
theme.icon_color = "#ffffff"

-- top bar
theme.bg_normal     = "#000000"
theme.bg_focus      = "#9772FB"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.wibar_type    = 'dock'
theme.wibar_border_width    = 0
theme.wibar_margin          = 4
theme.wibar_border_color =   "#000000" .. "00"
theme.wibar_height  = 32
-- theme.wibar_width   = 1200

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(2)
theme.border_normal = "#000000" .. "00"
theme.border_focus  = theme.bg_focus
theme.border_marked = "#91231c"


-- theme.taglist_font          =   "Font Awesome 6 Free "
theme.taglist_bg_empty      =   theme.bg_normal
theme.taglist_fg_empty      =   "#444444"

theme.tasklist_fg_normal	= dark
theme.tasklist_bg_normal	= theme.bg_normal
theme.tasklist_fg_focus	    = "#ffffff" 
theme.tasklist_bg_focus	    = theme.bg_normal
theme.tasklist_fg_urgent	= theme.bg_urgent
theme.tasklist_bg_urgent	= theme.bg_normal
theme.tasklist_fg_minimize  = "#444444"
theme.tasklist_bg_minimize  = theme.bg_normal 
theme.tasklist_spacing      =   0
theme.tasklist_align        =   "center"
theme.tasklist_disable_icon = false
theme.tasklist_disable_task_name = false
theme.tasklist_plain_task_name = true


-- beautiful.tasklist_fg_normal	The default foreground (text) color.
-- beautiful.tasklist_bg_normal	The default background color.
-- beautiful.tasklist_fg_focus	The focused client foreground (text) color.
-- beautiful.tasklist_bg_focus	The focused client background color.
-- beautiful.tasklist_fg_urgent	The urgent clients foreground (text) color.
-- beautiful.tasklist_bg_urgent	The urgent clients background color.
-- beautiful.tasklist_fg_minimize	The minimized clients foreground (text) color.
-- beautiful.tasklist_bg_minimize	The minimized clients background color.
-- beautiful.tasklist_bg_image_normal	The elements default background image.
-- beautiful.tasklist_bg_image_focus	The focused client background image.
-- beautiful.tasklist_bg_image_urgent	The urgent clients background image.
-- beautiful.tasklist_bg_image_minimize	The minimized clients background image.
-- beautiful.tasklist_disable_icon	Disable the tasklist client icons.
-- beautiful.tasklist_disable_task_name	Disable the tasklist client titles.
-- beautiful.tasklist_plain_task_name	Disable the extra tasklist client property notification icons.
-- beautiful.tasklist_font	The tasklist font.
-- beautiful.tasklist_align	The focused client alignment.
-- beautiful.tasklist_font_focus	The focused client title alignment.
-- beautiful.tasklist_font_minimized	The minimized clients font.
-- beautiful.tasklist_font_urgent	The urgent clients font.
-- beautiful.tasklist_spacing	The space between the tasklist elements.
-- beautiful.tasklist_shape	The default tasklist elements shape.
-- beautiful.tasklist_shape_border_width	The default tasklist elements border width.
-- beautiful.tasklist_shape_border_color	The default tasklist elements border color.
-- beautiful.tasklist_shape_focus	The focused client shape.
-- beautiful.tasklist_shape_border_width_focus	The focused client border width.
-- beautiful.tasklist_shape_border_color_focus	The focused client border color.
-- beautiful.tasklist_shape_minimized	The minimized clients shape.
-- beautiful.tasklist_shape_border_width_minimized	The minimized clients border width.
-- beautiful.tasklist_shape_border_color_minimized	The minimized clients border color.
-- beautiful.tasklist_shape_urgent	The urgent clients shape.
-- beautiful.tasklist_shape_border_width_urgent	The urgent clients border width.
-- beautiful.tasklist_shape_border_color_urgent	The urgent clients border color.

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(5)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.bg_focus
)
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, theme.fg_normal
-- )

theme.taglist_squares_unsel =  "~/.config/awesome/themes~/default/taglist/square_b.png"


-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(30)
theme.menu_width  = dpi(200)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

theme.wallpaper = themes_path.."default/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
