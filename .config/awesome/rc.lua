-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- Load Debian menu entries
--require("debian.menu")

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
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/liz/.config/awesome/heroku/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
--    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen
--    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
--for s = 1, screen.count() do
    -- Each screen has its own tag table.
--    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
--end

tag_settings = {
   {"₁ etc",    awful.layout.suit.floating,  "1" , nil},
   {"₂ web",    awful.layout.suit.tile.left, "2", "firefox"},
   {"₃ sh1",    awful.layout.suit.tile.left, "3", terminal},
   {"₄ sh2",    awful.layout.suit.tile.left, "4", terminal},
   {"₅ sh3",    awful.layout.suit.tile.left, "5", terminal},
   {"· im",     awful.layout.suit.tile.left, "'", "hipchat"},
   {", irc",    awful.layout.suit.tile.left, ",", "chromium https://www.irccloud.com"},
   {". media1", awful.layout.suit.tile.left, ".", "chromium --app=https://rdio.com"},
   {"ₚ media2", awful.layout.suit.floating,  "p", "gimp"},
   {"ᵧ etc2",   awful.layout.suit.floating,  "y", nil}
}

tag_names = {}
tag_layouts = {}

for i, tag in ipairs(tag_settings) do
   tag_names[i] = tag[1]
   tag_layouts[i] = tag[2]
end

for s = 1, screen.count() do
      tags[s] = awful.tag(tag_names, s, tag_layouts)
end
-- }}}


mytextclock = awful.widget.textclock()
--[[

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()
mytextbox = wibox.widget.textbox()
netinfobox = wibox.widget.textbox()
cpu0graph = awful.widget.graph()
cpu0graph:set_width(150)
cpu0graph:set_height(10)
cpu0graph:set_stack(true)
cpu0graph:set_background_color(beautiful.bg_normal)
cpu0graph:set_stack_colors({beautiful.fg_normal,beautiful.fg_focus})
cpu0graph:set_max_value(2)
memgraph = awful.widget.progressbar()
memgraph:set_width(150)
memgraph:set_background_color(beautiful.bg_normal)
memgraph:set_color(beautiful.fg_normal)
memgraph:set_border_color(beautiful.fg_normal)
memgraph:set_height(5)
batgraph = awful.widget.progressbar()
batgraph:set_width(150)
batgraph:set_background_color(beautiful.fg_normal)
batgraph:set_color(beautiful.bg_normal)
batgraph:set_border_color(beautiful.fg_normal)


jiffies = {}
function activecpu()
   local t = {}
   for line in io.lines("/proc/stat") do
       local cpu, newjiffies = string.match(line, "(cpu%d*)\ +(%d+)")
       if cpu and newjiffies then
           if not jiffies[cpu] then
               jiffies[cpu] = newjiffies
           end
           t[cpu] = (newjiffies - jiffies[cpu]) / 100
           jiffies[cpu] = newjiffies
       end
   end
   return t
end

function cputemp()
    return io.input('/sys/devices/platform/thinkpad_hwmon/temp1_input'):read("*n") / 1000
end

function batpercent()
    test, val = pcall(function()
        return io.input('/sys/devices/platform/smapi/BAT0/remaining_percent'):read("*n")
    end)
    if test and val then
        return val / 100
    else
        return 0
    end
end

function memoryusage()
    local memtotal = nil
    local active = nil
    for line in io.lines("/proc/meminfo") do
        if not memtotal then
            memtotal = string.match(line, "MemTotal:\ +(%d+)")
        end
        if not active then
            active = string.match(line, "Active:\ +(%d+)")
        end

        if active and memtotal then
            return active / memtotal
        end
    end
    return 0
end

function netinfo()
    local status = os.execute("/home/sib/Scripts/wicd-status.py") / 256 -- Why
    local colour = ""

    if status == 0 then
        colour = "green"
    elseif status == 1 then
        colour = "yellow"
    elseif status == 2 then
        colour = "red"
    else
        colour = "white"
    end
    return "  <span color='" .. colour .. "'>N</span> "
end

mytimer = timer({timeout = 1})
mytimer:connect_signal("timeout", function()
    local t = activecpu()
    cpu0graph:add_value(t.cpu0, 1)
    cpu0graph:add_value(t.cpu1, 2)
    mytextbox:set_markup("    " .. cputemp() .. "°C    ")
    memgraph:set_value(memoryusage())
    batgraph:set_value(1 - batpercent())
    netinfobox:set_markup(netinfo())
end)
mytimer:start()

]]
-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
local mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
--    awful.button({ }, 4, awful.tag.viewnext),
--    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key( { modkey }, ";",
        function()
            awful.menu.clients( { width = 250 }, { keygrabber = true } )
        end ),

    -- Standard program
    awful.key({ modkey,           }, "\\", function () awful.util.spawn(terminal) end),
    awful.key({ modkey            }, "Return",function ()
       for i, tag in ipairs(tag_settings) do
          if tags[1][i].selected then
             awful.util.spawn(tag[4])
          end
       end
    end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", function ()
       awful.util.spawn("/home/liz/Scripts/awesome_quit.sh")
    end),
    awful.key({ modkey            }, "b",     function ()
                                                  awful.util.spawn("gnome-screensaver-command -l")
                                              end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey,           }, "i",     function ()
        awful.util.spawn("pkill firefox")
   end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = " Lua: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Set up key bindings
for i, tag in ipairs(tag_settings)  do
    key = tag[3]
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, key,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, key,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, key,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, key,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end


clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "Evince"},
        properties = { tag = tags[1][1] } },
    { rule = { class = "Firefox" },
        properties = { tag = tags[1][2] } },
    -- Full-screen flash videos
    { rule = { class = "Plugin-container"},
        properties = { floating = true } },
    { rule = { class = "Vlc" },
        properties = { floating = true } },
    { rule = { name = "Wicd Network Manager"},
        properties = { floating = true } },
    { rule = { class = "HipChat" },
        properties = { tag = tags[1][5] } },
    { rule = { class = "Skype" },
        properties = { tag = tags[1][5], size_hints_honor = false} },
    { rule = { class = "Rhythmbox" },
        properties = { tag = tags[1][7] } },
    { rule = { class = "Gimp" },
        properties = { tag = tags[1][8] } },
    { rule = { class = "FTL" },
        properties = { tag = tags[1][1] } },
    { rule = { class = "Steam" },
        properties = { tag = tags[1][1] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

awful.util.spawn("dex -a -e Awesome")
awful.util.spawn("xmodmap /home/liz/.Xmodmap")
