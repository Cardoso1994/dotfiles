# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


import os
import re
import socket
import subprocess
from libqtile.config import Drag, Key, Screen, Group, Drag, Click, Rule, Match
from libqtile.config import ScratchPad, DropDown
from libqtile.command import lazy#, Client
from libqtile import layout, bar, widget, hook
from libqtile.widget import Spacer


# for multimonitor on the fly support
from Xlib import display as xdisplay

###############################################################################
# => MOD KEYS
###############################################################################
#mod4 or mod = super key
mod = "mod4"
mod1 = "alt"
mod2 = "control"
home = os.path.expanduser('~')


@lazy.function
def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)

@lazy.function
def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


###############################################################################
# => MONITORS ON THE FLY
###############################################################################
# function to get the num_monitors on the fly
# added by Cardoso via https://github.com/qtile/qtile/wiki/screens
@hook.subscribe.restart
def get_num_monitors():
    num_monitors = 0
    try:
        display = xdisplay.Display()
        screen = display.screen()
        resources = screen.root.xrandr_get_screen_resources()

        for output in resources.outputs:
            monitor = display.xrandr_get_output_info(output,
                                            resources.config_timestamp)
            preferred = False
            if hasattr(monitor, "preferred"):
                preferred = monitor.preferred
            elif hasattr(monitor, "num_preferred"):
                preferred = monitor.num_preferred
            if preferred:
                num_monitors += 1
    except Exception as e:
        return 1
    else:
        return num_monitors

num_monitors = get_num_monitors()
# num_monitors = 1
###############################################################################
# => General Configuration Variables
###############################################################################

###################
# gruvbox colors
###################
bg = "#282828"
red = "#cc241d"
red_1 = "#9d0006"
green = "#98971a"
yellow = "#d79921"
blue = "#458588"
purple = "#b16286"
aqua = "#689d68"
gray = "#a89984"
darkgray = "#1d2021"


###############################################################################
# => KEY COMBINATIONS
###############################################################################
keys = [
    # SUPER + FUNCTION KEYS
    Key([mod], "Return", lazy.spawn('st')),
    Key([mod], "Escape", lazy.spawn('xkill')),
    Key([mod], "d", lazy.spawn('dmenu_run -i -nb ' + darkgray
                                    + ' -nf ' + aqua + ' -sb ' + green
                                    + ' -sf ' + darkgray + ' -fn '
                                    + "'Cascadia Code PL:semilight:pixelsize=28'")),
    Key([mod], "b", lazy.hide_show_bar()),
    # TOUCHPAD ON - OFF
    Key([mod], "p", lazy.spawn(
            '/home/cardoso/.config/scripts/pad_on_off.sh off')),
    Key([mod], "o", lazy.spawn(
            '/home/cardoso/.config/scripts/pad_on_off.sh on')),
    # SUPER + SHIFT KEYS
    Key([mod, "shift"], "Return", lazy.spawn("st"
                        + " -e /home/cardoso/.config/vifm/scripts/vifmrun")),
    Key([mod, "shift"], "q", lazy.window.kill()),
    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod, "shift"], "x", lazy.spawn('/home/cardoso/.config/scripts/exit')),

    Key([mod, "shift"], "d", lazy.spawn(f'j4-dmenu-desktop --dmenu="dmenu -i'
                               + f" -nb '{darkgray}'" + f" -nf '{aqua}' "
                               + f" -sb '{green}' -sf '{darkgray}' "
                               + f" -fn 'Cascadia Code Pl:semilight:pixelsize=28'"
                               + '"')),

    Key([mod, "shift"], "s", lazy.spawn("/home/cardoso/.config/"
                                        + "scripts/screen_layout")),
    Key([mod, "shift"], "v", lazy.spawn("/home/cardoso/.config/"
                                        + "scripts/mpv_web")),
    # MULTIMEDIA KEYS
    # INCREASE/DECREASE BRIGHTNESS
    Key([], "XF86MonBrightnessUp", lazy.spawn('xbacklight -inc 5')),
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -dec 5")),

    # INCREASE/DECREASE/MUTE VOLUME
    Key([], "XF86AudioMute", lazy.spawn("amixer -D pulse set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn(
                                    "amixer -D pulse sset Master '5%-'")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn(
                                    "amixer -D pulse sset Master '5%+'")),

    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioStop", lazy.spawn("playerctl stop")),

    # Key([], "XF86AudioPlay", lazy.spawn("mpc toggle")),
    # Key([], "XF86AudioNext", lazy.spawn("mpc next")),
    # Key([], "XF86AudioPrev", lazy.spawn("mpc prev")),
    # Key([], "XF86AudioStop", lazy.spawn("mpc stop")),

    # QTILE LAYOUT KEYS
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod], "space", lazy.next_layout()),

    # CHANGE FOCUS OF WINDOWS
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),


    # RESIZE UP, DOWN, LEFT, RIGHT
    Key([mod, "control"], "l",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "h",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "k",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "j",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),
    Key([mod, "control"], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),


    # FLIP LAYOUT FOR MONADTALL/MONADWIDE
    Key([mod, "shift"], "space", lazy.layout.flip()),

    # FLIP LAYOUT FOR BSP
    # Key([mod, "mod1"], "k", lazy.layout.flip_up()),
    # Key([mod, "mod1"], "j", lazy.layout.flip_down()),
    # Key([mod, "mod1"], "l", lazy.layout.flip_right()),
    # Key([mod, "mod1"], "h", lazy.layout.flip_left()),

    # MOVE WINDOWS UP OR DOWN
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),

    # MOVE WINDOWS UP OR DOWN MONADTALL/MONADWIDE LAYOUT
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Left", lazy.layout.swap_left()),
    Key([mod, "shift"], "Right", lazy.layout.swap_right()),

    # MOVE TO OTHER MONITOR
    Key([mod], "m", lazy.next_screen()),

    # COLUMNS LAYOUT STACK OR SPLIT
    Key([mod], "w", lazy.layout.toggle_split()),

    # TOGGLE FLOATING LAYOUT
    Key([mod, "shift"], "t", lazy.window.toggle_floating()),
    ]


###############################################################################
# => GROUPS
###############################################################################
groups = []

group_matches = [
    # workspace 1
    [Match(wm_class=[])],
    # workspace 2
    [Match(wm_class=[ "Atom", "Subl3", "Spyder", "RStudio", "TeXstudio",
                     "texstudio", "atom", "subl3", "octave-gui", "brackets",
                     "code-oss", "code", "telegramDesktop", "discord", ])],
    # workspace 3
    [Match(wm_class=["chromium-browser", "Chromium-browser", "Firefox",
                     "firefox", "Navigator", "brave-browser",
                     "Brave-browser"])],
    # workspace 4
    [Match(wm_class=["Xreader", "Zathura", "zathura", "org.pwmt.zathura"])],
    # workspace 5
    [Match(wm_class=["Thunderbird", "libreoffice-startcenter",
                     "libreoffice-writer", "libreoffice-impress",
                     "libreoffice-calc", "libreoffice", ])],
    # workspace 6
    [Match(wm_class=["Vlc","vlc", "FreeCAD", "freecad", "Nitrogen", "nitrogen",
              "matplotlib", "Paraview", "paraview", "mpv", "Mpv", "gl"])],
    # workspace 7
    [Match(wm_class=["VirtualBox Manager", "VirtualBox Machine", "Vmplayer",
              "virtualbox manager", "virtualbox machine", "vmplayer", ])],
    # workspace 8
    [Match(wm_class=["Thunar", "thunar", "Pcmanfm", "Pcmanfm-qt", "pcmanfm",
                     "pcmanfm-qt"])],
    # workspace 9
    [Match(wm_class=[None])],
    # workspace 0 (10)
    [Match(wm_class=[None])],
]
# FOR QWERTY KEYBOARDS
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0",]

group_labels = ["  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ",
                "  ",]


group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall",
                 "monadtall", "monadtall", "monadtall", "monadtall",
                 "monadtall", "monadtall",]

groups_screen_0 = {"2"}
groups_screen_1 = {"3", "4", "6", "0"}
groups_any_screen = set(group_names) - (groups_screen_0 | groups_screen_1)

for i in range(len(group_names)):
    groups.append(
            Group(
                name=group_names[i],
                layout=group_layouts[i].lower(),
                label=group_labels[i],
                matches=group_matches[i]
            ))
    # groups.append(
    #     Group(
    #         name=group_names[i],
    #         layout=group_layouts[i].lower(),
    #         label=group_labels[i],
    #     ))

#####################################
# => GROUP KEYS
#####################################
# if num_monitors == 1:
if True:
    for i in groups:
        keys.extend([
            #CHANGE WORKSPACES
            Key([mod], i.name, lazy.group[i.name].toscreen()),
            # Key([mod], "Tab", lazy.screen.next_group()),
            # Key(["mod1"], "Tab", lazy.screen.next_group()),
            # Key(["mod1", "shift"], "Tab", lazy.screen.prev_group()),

            # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
            Key([mod, "control"], i.name, lazy.window.togroup(i.name)),
            # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND GO TO WORKSPACE
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name) ,
                lazy.group[i.name].toscreen()),
        ])
else:
    for i in groups:
        # ASSIGN WORKSPACE TO SPECIFIC MONITOR
        # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND GO TO WORKSPACE IN
        # SPECIFIC MONITOR

        # Cardoso Approach
        if i.name in groups_screen_0:
            keys.extend([
                # Key([mod], i.name, lazy.group[i.name].toscreen(0),
                #     lazy.to_screen(0)),
                Key([mod], i.name, lazy.to_screen(0),
                    lazy.group[i.name].toscreen(0)),
                # Key([mod, "shift"], i.name, lazy.window.togroup(i.name) ,
                #     lazy.group[i.name].toscreen(0), lazy.to_screen(0))
                Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
                    lazy.to_screen(0), lazy.group[i.name].toscreen(0))
            ])
        elif i.name in groups_screen_1:
            keys.extend([
                # Key([mod], i.name, lazy.group[i.name].toscreen(1),
                #     lazy.to_screen(1)),
                Key([mod], i.name, lazy.to_screen(1),
                    lazy.group[i.name].toscreen(1)),
                # Key([mod, "shift"], i.name, lazy.window.togroup(i.name) ,
                #     lazy.group[i.name].toscreen(1), lazy.to_screen(1)),
                Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
                    lazy.to_screen(1), lazy.group[i.name].toscreen(1))
            ])
        else:
            keys.extend([
                Key([mod], i.name, lazy.group[i.name].toscreen()),
                Key([mod, "shift"], i.name, lazy.window.togroup(i.name) ,
                    lazy.group[i.name].toscreen()),
            ])

        keys.extend([
            # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
            Key([mod, "control"], i.name, lazy.window.togroup(i.name)),
            # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND GO TO WORKSPACE
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name) ,
            #     lazy.group[i.name].toscreen()),
        ])

###############
# SCRATCHPAD
###############
# groups.append(
#     ScratchPad("scratchpad", [
#         # define a drop down terminal.
#         # it is placed in the upper third of screen by default.
#         DropDown("pomotroid", "pomotroid", opacity=0.88, height=0.65,
#                  width=0.40, x = 0.5),
#
#         # define another terminal exclusively for qshell at different position
#         DropDown("qshell", "/usr/bin/termite -e qshell",
#                  x=0.05, y=0.4, width=0.9, height=0.6, opacity=0.9,
#                  on_focus_lost_hide=True)
#     ]), )
#
# keys.extend([
#     # Scratchpad
#     # toggle visibiliy of above defined DropDown named "term"
#     Key([], 'F12', lazy.group['scratchpad'].dropdown_toggle('pomotroid')),
#     Key([], 'F11', lazy.group['scratchpad'].dropdown_toggle('qshell')),
# ])


###################
# gruvbox colors
###################
bg = "#282828"
red = "#cc241d"
red_1 = "#9d0006"
green = "#98971a"
yellow = "#d79921"
blue = "#458588"
purple = "#b16286"
aqua = "#689d68"
gray = "#a89984"
darkgray = "#1d2021"

###############################################################################
# => LAYOUTS
###############################################################################
border_width_   = 4
border_focus_   = red_1
border_normal_  = darkgray
margin_         = 4

def init_layout_theme():
    return {"margin":margin_,
            "border_width":border_width_,
            "border_focus": border_focus_,
            "border_normal": border_normal_
            }

layout_theme = init_layout_theme()


layouts = [
    layout.Columns(num_columns=2, insert_position=1, margin=margin_,
                   border_focus=border_focus_, border_normal=border_normal_,
                   grow_amount=2, border_width=border_width_),
    layout.MonadTall(margin=margin_, border_width=border_width_,
                     border_focus=border_focus_,
                     border_normal=border_normal_, ratio=0.60, max_ratio=0.75,
                     min_ratio=0.25, single_border_width=0,
                     single_margin=0),
    layout.MonadWide(align=0, margin=margin_, border_width=border_width_,
                     border_focus=border_focus_,
                     border_normal=border_normal_, ratio=0.60, max_ratio=0.80,
                     min_ratio=0.15, single_border_width=0,
                     single_margin=0),
    # layout.Matrix(**layout_theme),
    # layout.Bsp(**layout_theme),
    # layout.Floating(**layout_theme),
    # layout.RatioTile(**layout_theme),
    layout.Max(**layout_theme)
]

###############################################################################
# => BAR
###############################################################################
# COLORS FOR THE BAR

def init_colors():
    return [["#2F343F", "#2F343F"], # color 0
            ["#2F343F", "#2F343F"], # color 1
            ["#c0c5ce", "#c0c5ce"], # color 2
            ["#fba922", "#fba922"], # color 3
            ["#3384d0", "#3384d0"], # color 4
            ["#f3f4f5", "#f3f4f5"], # color 5
            ["#cd1f3f", "#cd1f3f"], # color 6
            ["#62FF00", "#62FF00"], # color 7
            ["#6790eb", "#6790eb"], # color 8
            ["#a9a9a9", "#a9a9a9"]] # color 9


colors = init_colors()

# WIDGETS FOR THE BAR
def init_widgets_defaults():
    return dict(font="FuraCode Nerd Font",
                fontsize=18,
                padding=2,
                background=darkgray,
                foreground=purple
                )

widget_defaults = init_widgets_defaults()

def init_widgets_list():
    prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
    widgets_list = [
               widget.GroupBox(
                   font=widget_defaults['font'],
                   fontsize = widget_defaults['fontsize'] + 10,
                   margin_y = 0,
                   margin_x = 0,
                   padding_y = 6,
                   padding_x = 5,
                   borderwidth = 0,
                   disable_drag = True,
                   active = aqua,
                   rounded = False,
                   highlight_method = "text",
                   this_current_screen_border = yellow, # current group
                   block_highlight_text_color = yellow,
                   foreground = blue,
                   background = widget_defaults['background'],
                   hide_unused=True,
                   urgent_border=red_1,
                   urgent_text=red_1,
                   urgent_alert_method = 'text'
                    ),
               widget.Sep(
                    linewidth = 1,
                    padding = 10,
                    foreground = widget_defaults['foreground'],
                    background = widget_defaults['background']
                    ),
               widget.CurrentLayout(
                    font = widget_defaults['font'],
                    fontsize = widget_defaults['fontsize'] + 5,
                    foreground = blue,
                    background = widget_defaults['background']
                    ),
               widget.Sep(
                    linewidth = 1,
                    padding = 10,
                    foreground = widget_defaults['foreground'],
                    background = widget_defaults['background']
                    ),
                widget.Spacer(),
               # widget.WindowName(
               #      font=widget_defaults['font'],
               #      fontsize = widget_defaults['fontsize'],
               #      foreground = blue,
               #      background = widget_defaults['background']
               #      ),
               widget.Sep(
                    linewidth = 1,
                    padding = 10,
                    foreground = widget_defaults['foreground'],
                    background = widget_defaults['background']
                    ),
               widget.TextBox(
                    font=widget_defaults['font'],
                    text="  ",
                    foreground=colors[6],
                    background=widget_defaults['background'],
                    padding = 0,
                    fontsize=widget_defaults['fontsize'] + 6
                    ),
               widget.MemoryGraph(
                    border_color = purple,
                    fill_color = yellow,
                    graph_color = yellow,
                    background=widget_defaults['background'],
                    border_width = 1,
                    line_width = 1,
                    core = "all",
                    type = "box"
                    ),
                widget.Memory(
                    background = widget_defaults['background'],
                    font = widget_defaults['font'],
                    fontsize = widget_defaults['fontsize'] + 3,
                    foreground = yellow,
                ),
               widget.Sep(
                    linewidth = 1,
                    padding = 10,
                    foreground = widget_defaults['foreground'],
                    background = widget_defaults['background']
                    ),
               widget.TextBox(
                    font=widget_defaults['font'],
                    text=" 力 ",
                    foreground=red,
                    background=widget_defaults['background'],
                    padding = 0,
                    fontsize=widget_defaults['fontsize'] + 5
                    ),
               widget.CPUGraph(
                    border_color = purple,
                    fill_color = colors[8],
                    graph_color = aqua,
                    background=widget_defaults['background'],
                    border_width = 1,
                    line_width = 1,
                    core = "all",
                    type = "box"
                    ),
               widget.CPU(
                    font=widget_defaults['font'],
                    fontsize=widget_defaults['fontsize'] + 3,
                   format='L: {load_percent}% GHz: {freq_current}',
                    foreground=aqua
                    ),
               widget.TextBox(
                    font=widget_defaults['font'],
                    text="  ",
                    foreground=red,
                    background=widget_defaults['background'],
                    padding = 0,
                    fontsize=widget_defaults['fontsize'] + 3
                    ),
              widget.ThermalSensor(
                    foreground = aqua,
                    foreground_alert = red,
                    background = widget_defaults['background'],
                    metric = True,
                    padding = 3,
                    threshold = 80,
                    fontsize=widget_defaults['fontsize'] + 3,
                    tag = "temp1"
                    ),
               widget.Sep(
                    linewidth = 1,
                    padding = 10,
                    foreground = widget_defaults['foreground'],
                    background = widget_defaults['background']
                    ),
               widget.TextBox(
                    font=widget_defaults['font'],
                    text="  ",
                    foreground=green,
                    background=widget_defaults['background'],
                    padding = 0,
                    fontsize=widget_defaults['fontsize']
                    ),
               widget.Clock(
                    foreground = blue,
                    background = widget_defaults['background'],
                    fontsize = widget_defaults['fontsize'] + 3,
                    format="%Y-%m-%d %H:%M"
                    ),
               widget.Sep(
                    linewidth = 1,
                    padding = 10,
                    foreground = purple,
                    background = widget_defaults['background']
                    ),
               widget.Systray(
                    background=widget_defaults['background'],
                    icon_size=22,
                    padding = 4
                    ),
              ]
    return widgets_list

widgets_list = init_widgets_list()


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2

widgets_screen1 = init_widgets_screen1()
widgets_screen2 = init_widgets_screen2()

###############################################################################
# SCREENS
###############################################################################
def init_screens():
    return [Screen(bottom=bar.Bar(widgets=init_widgets_screen1(), size=26))]
            # Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=26))]

def init_screens_on_the_fly():
    screens = [Screen(bottom=bar.Bar(widgets=init_widgets_screen1(), size=26))]

    for _ in range(num_monitors - 1):
        screens.append(
            Screen(bottom=bar.Bar(widgets=init_widgets_screen2(), size=26))
        )

    return screens

print (f"num_monitors is: {num_monitors}")
if num_monitors == 1:
    screens = init_screens()
else:
    screens = init_screens_on_the_fly()


###############################################################################
# => MOUSE CONFIGURATION
###############################################################################
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size())
]

dgroups_key_binder = None
dgroups_app_rules = []

###############################################################################
# => ASSIGN APPLICATIONS TO A SPECIFIC GROUPNAME
###############################################################################

# @hook.subscribe.client_new
# def assign_app_group(client):
#     d = {}
#     #########################################################
#     ################ assign apps to groups ##################
#     #########################################################
#     d["1"] = ["st","St", "urxvt", "URxvt", ]
#
#     d["2"] = [ "Atom", "Subl3", "Spyder", "RStudio", "TeXstudio", "texstudio",
#                "atom", "subl3", "octave-gui", "brackets", "code-oss", "code", "telegramDesktop", "discord", ]
#
#     d["3"] = ["chromium-browser", "Chromium-browser", "Firefox", "firefox",
#               "Navigator", "brave-browser", "Brave-browser"]
#
#     d["4"] = ["Xreader", "Zathura", "zathura", "org.pwmt.zathura"]
#
#     d["5"] = ["Thunderbird", "libreoffice-startcenter", "libreoffice-writer",
#               "libreoffice-impress", "libreoffice-calc", "libreoffice", ]
#
#     d["6"] = ["Vlc","vlc", "FreeCAD", "freecad", "Nitrogen", "nitrogen",
#               "matplotlib", "Paraview", "paraview", "mpv", "Mpv", "gl"]
#     d["7"] = ["VirtualBox Manager", "VirtualBox Machine", "Vmplayer",
#               "virtualbox manager", "virtualbox machine", "vmplayer", ]
#     d["8"] = ["Thunar", "Nemo", "Caja", "Nautilus", "org.gnome.Nautilus", "Pcmanfm", "Pcmanfm-qt",
#               "thunar", "nemo", "caja", "nautilus", "org.gnome.nautilus", "pcmanfm", "pcmanfm-qt", ]
#     d["9"] = ["Evolution", "Geary", "Mail", "Thunderbird",
#               "evolution", "geary", "mail", "thunderbird" ]
#     d["0"] = ["Spotify", "Pragha", "Clementine", "Deadbeef", "Audacious",
#               "spotify", "pragha", "clementine", "deadbeef", "audacious" ]
#     ##########################################################
#     wm_class = client.window.get_wm_class()[0]
#
#     for i in range(len(d)):
#         if wm_class in list(d.values())[i]:
#             group = list(d.keys())[i]
#             client.togroup(group)
#            # if group in groups_screen_0:
#            #     client.group.cmd_toscreen(0)
#            # elif group in groups_screen_1:
#            #     client.group.cmd_toscreen(1)
#            # else:
#            #     client.group.cmd_toscreen(0)


###############################################################################
# => FORCING FLOATING IN APPLICATIONS
###############################################################################
main = None

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])

@hook.subscribe.startup
def start_always():
    # Set the cursor to something sane in X
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])

@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True

floating_types = ["notification", "toolbar", "splash", "dialog"]


follow_mouse_focus = True
bring_front_click = "floating_only"
cursor_warp = True
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'xfce4-appfinder'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},
    {'wmclass': 'makebranch'},
    {'wmclass': 'maketag'},
    {'wmclass': 'Arandr'},
    {'wmclass': 'feh'},
    {'wmclass': 'Galculator'},
    {'wmclass': 'Oblogout'},
    {'wmclass': 'xfce4-terminal'},
    {'wname': 'branchdialog'},
    {'wname': 'Open File'},
    {'wname': 'pinentry'},
    {'wmclass': 'ssh-askpass'},

],  fullscreen_border_width = border_width_, border_width = border_width_,
                                  border_focus=border_focus_,
                                  border_normal=border_normal_)
auto_fullscreen = True

focus_on_window_activation = "smart" # or smart

wmname = "LG3D"
