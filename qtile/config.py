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
from libqtile.config import Drag, Key, Screen, Group, Drag, Click, Rule
from libqtile.command import lazy, Client
from libqtile import layout, bar, widget, hook
from libqtile.widget import Spacer
# import arcobattery
# import arcomemory


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
    print(type(qtile))
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


###############################################################################
# => MONITORS ON THE FLY
###############################################################################
# function to get the num_monitors on the fly
# added by Cardoso via https://github.com/qtile/qtile/wiki/screens
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

###############################################################################
# => KEY COMBINATIONS
###############################################################################
keys = [

    # SUPER + FUNCTION KEYS

    # Key([mod], "Return", lazy.spawn('urxvt')),
    # Key([mod], "Return", lazy.spawn('st')),
    Key([mod], "Return", lazy.spawn('/home/desarrollo/.cargo/bin/alacritty')),
    Key([mod], "d", lazy.spawn('dmenu_run -i -fn' + ' "InconsolataGo"')),
    Key([mod], "v", lazy.spawn('pavucontrol')),
    Key([mod], "x", lazy.spawn('oblogout')),
    Key([mod], "Escape", lazy.spawn('xkill')),


    # SUPER + SHIFT KEYS
    Key([mod, "shift"], "Return",
        lazy.spawn(
            "/home/desarrollo/.cargo/bin/alacritty"
            + " -e /home/desarrollo/.config/vifm/scripts/vifmrun")),
        # lazy.spawn("st /home/desarrollo/.config/vifm/scripts/vifmrun")),
    Key([mod, "shift"], "q", lazy.window.kill()),
    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod, "shift"], "x", lazy.shutdown()),
    Key([mod, "shift"], "d", lazy.spawn('xfce4-appfinder')),

    # CONTROL + ALT KEYS

    # ALT + ... KEYS

    # CONTROL + SHIFT KEYS

    Key([mod2, "shift"], "Escape", lazy.spawn('xfce4-taskmanager')),

    # SCREENSHOTS
    Key([mod2], "Print", lazy.spawn('xfce4-screenshooter')),
    Key([mod2, "shift"], "Print", lazy.spawn('gnome-screenshot -i')),

    # MULTIMEDIA KEYS

    # INCREASE/DECREASE BRIGHTNESS
    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight -inc 5")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -dec 5")),

    # INCREASE/DECREASE/MUTE VOLUME
    Key([], "XF86AudioMute", lazy.spawn("amixer -D pulse set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -D pulse sset Master '5%-'")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn(" amixer -D pulse sset Master '5%+'")),

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
    Key([mod, "shift"], "f", lazy.layout.flip()),

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
    Key([mod, "shift"], "m", lazy.next_screen()),
    Key([mod, "shift"], "n", lazy.prev_screen()),

    # TOGGLE FLOATING LAYOUT
    Key([mod, "shift"], "space", lazy.window.toggle_floating()),
    ]


###############################################################################
# => GROUPS
###############################################################################
groups = []

# FOR QWERTY KEYBOARDS
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0",]

# group_labels = ["", "", "", "", "", "", "", "", "", "",]
group_labels = ["", "", "", "", "", "", "", "", "",  "",]
# group_labels = ["", "", "", "", "", "", "", "", "", "",]


group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall",
                 "monadtall", "monadtall", "monadtall", "monadtall",
                 "monadtall", "monadtall",]

groups_screen_0 = ["2"]
groups_screen_1 = ["3", "6", "0"]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

#####################################
# => GROUP KEYS
#####################################
if num_monitors == 1:
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
        if i.name in groups_screen_0:
            keys.extend([
                Key([mod], i.name, lazy.group[i.name].toscreen(0))
            ])
        elif i.name in groups_screen_1:
            keys.extend([
                Key([mod], i.name, lazy.group[i.name].toscreen(1))
            ])
        else:
            keys.extend([
                Key([mod], i.name, lazy.group[i.name].toscreen())
            ])

        keys.extend([
            # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
            Key([mod, "control"], i.name, lazy.window.togroup(i.name)),
            # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND GO TO WORKSPACE
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name) ,
                lazy.group[i.name].toscreen()),
        ])

###############################################################################
# => LAYOUTS
###############################################################################
border_width_ = 1
border_focus_ = "#f57800"
border_normal_ = "#123e7c"
def init_layout_theme():
    return {"margin":6,
            "border_width":border_width_,
            "border_focus": border_focus_,
            "border_normal": border_normal_
            }

layout_theme = init_layout_theme()


layouts = [
    layout.Columns(num_columns=2, insert_position=1, margin=5,
                   border_focus=border_focus_, border_normal=border_normal_,
                   grow_amount=2),
    layout.MonadTall(margin=5, border_width=border_width_,
                     border_focus=border_focus_,
                     border_normal=border_normal_, ratio=0.65, max_ratio=0.75,
                     min_ratio=0.25),
    layout.MonadWide(align=0, margin=5, border_width=border_width_,
                     border_focus=border_focus_,
                     border_normal=border_normal_, ratio=0.65, max_ratio=0.85,
                     min_ratio=0.15),
    # layout.Matrix(**layout_theme),
    # layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
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
    # return dict(font="Noto Sans",
    return dict(font="Inconsolata Nerd Font",
                fontsize = 12,
                padding = 2,
                background=colors[1])

widget_defaults = init_widgets_defaults()

def init_widgets_list():
    prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
    widgets_list = [
               widget.GroupBox(font="Inconsolata Nerd Font",
                        fontsize = 16,
                        margin_y = -1,
                        margin_x = 0,
                        padding_y = 6,
                        padding_x = 5,
                        borderwidth = 0,
                        disable_drag = True,
                        active = colors[9],
                        inactive = colors[5],
                        rounded = False,
                        highlight_method = "text",
                        this_current_screen_border = colors[8],
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.CurrentLayout(
                        font = "InconsolataGo Nerd Font Mono Bold",
                        fontsize = 16,
                        foreground = colors[5],
                        background = colors[1]
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.WindowName(font="InconsolataGo Nerd Font Mono",
                        fontsize = 16,
                        foreground = colors[5],
                        background = colors[1],
                        ),
        widget.Pomodoro(
                        fontsize = 16,
                        font = "InconsolataGo Nerd Font Mono",
                        background = colors[1],
                        foreground = colors[5],
                        length_pomodori = 22,
                        length_long_break = 15,
                        length_short_break = 5,
                        num_pomodori = 4,
                        update_interval = 5
                       ),
               # widget.Net(
               #          font="Noto Sans",
               #          fontsize=12,
               #          interface="enp0s31f6",
               #          foreground=colors[2],
               #          background=colors[1],
               #          padding = 0,
               #          ),
               # widget.Sep(
               #          linewidth = 1,
               #          padding = 10,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),
               # widget.NetGraph(
               #          font="Noto Sans",
               #          fontsize=12,
               #          bandwidth="down",
               #          interface="auto",
               #          fill_color = colors[8],
               #          foreground=colors[2],
               #          background=colors[1],
               #          graph_color = colors[8],
               #          border_color = colors[2],
               #          padding = 0,
               #          border_width = 1,
               #          line_width = 1,
               #          ),
               # widget.Sep(
               #          linewidth = 1,
               #          padding = 10,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),
               widget.TextBox(
                        font="FontAwesome",
                        text="  ",
                        foreground=colors[6],
                        background=colors[1],
                        padding = 0,
                        fontsize=16
                        ),
               widget.CPUGraph(
                        border_color = colors[2],
                        fill_color = colors[8],
                        graph_color = colors[8],
                        background=colors[1],
                        border_width = 1,
                        line_width = 1,
                        core = "all",
                        type = "box"
                        ),
                        # do not activate in Virtualbox - will break qtile
#              widget.ThermalSensor(
#                        foreground = colors[5],
#                        foreground_alert = colors[6],
#                        background = colors[1],
#                        metric = True,
#                        padding = 3,
#                        threshold = 80
#                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.TextBox(
                        font="FontAwesome",
                        text="  ",
                        foreground=colors[4],
                        background=colors[1],
                        padding = 0,
                        fontsize=16
                        ),
               # arcomemory.Memory(
               #          font="Noto Sans",
               #          fmt = '{MemUsed}/{MemTotal}M',
               #          update_interval = 1,
               #          fontsize = 12,
               #          foreground = colors[5],
               #          background = colors[1],
               #          ),
               # # battery option 1  or ArcoLinux Horizontal icons by default
               # widget.Sep(
               #          linewidth = 1,
               #          padding = 10,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),
               # arcobattery.BatteryIcon(
               #          padding=0,
               #          scale=0.7,
               #          y_poss=2,
               #          theme_path=home + "/.config/qtile/icons/battery_icons_horiz",
               #          update_interval = 5,
               #          background = colors[1]
               #          ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.TextBox(
                        font="FontAwesome",
                        text="  ",
                        foreground=colors[3],
                        background=colors[1],
                        padding = 0,
                        fontsize=16
                        ),
               widget.Clock(
                        foreground = colors[5],
                        background = colors[1],
                        fontsize = 12,
                        format="%Y-%m-%d %H:%M"
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.Systray(
                        background=colors[1],
                        icon_size=20,
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
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=26)),
            Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=26))]

def init_screens_on_the_fly():
    screens = [Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=26))]

    for _ in range(num_monitors - 1):
        screens.append(
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=26))
        )

    return screens


if num_monitors == 1:
    screens = init_screens()
else:
    screens = init_screens_on_the_fly()


screens = init_screens()

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

@hook.subscribe.client_new
def assign_app_group(client):
    d = {}
    #########################################################
    ################ assign apps to groups ##################
    #########################################################
    # d["1"] = ["Navigator", "Firefox", "Vivaldi-stable", "Vivaldi-snapshot", "Chromium", "Google-chrome", "Brave", "Brave-browser",
    #           "navigator", "firefox", "vivaldi-stable", "vivaldi-snapshot", "chromium", "google-chrome", "brave", "brave-browser", ]
    d["1"] = ["st","St", "urxvt", "URxvt", ]

    d["2"] = [ "Atom", "Subl3", "Spyder", "RStudio", "TeXstudio", "texstudio",
               "atom", "subl3", "octave-gui", "brackets", "code-oss", "code", "telegramDesktop", "discord", ]

    d["3"] = ["chromium-browser", "Chromium-browser", "Firefox", "firefox",
              "Navigator"]

    d["4"] = ["Xreader", "Zathura", "zathura", ]

    d["5"] = ["Thunderbird", "libreoffice-startcenter", "libreoffice-writer",
              "libreoffice-impress", "libreoffice-calc", "libreoffice", ]

    d["6"] = ["Vlc","vlc", "FreeCAD", "freecad", "Nitrogen", "nitrogen",
              "matplotlib", "Paraview", "paraview", ]
    d["7"] = ["VirtualBox Manager", "VirtualBox Machine", "Vmplayer",
              "virtualbox manager", "virtualbox machine", "vmplayer", ]
    d["8"] = ["Thunar", "Nemo", "Caja", "Nautilus", "org.gnome.Nautilus", "Pcmanfm", "Pcmanfm-qt",
              "thunar", "nemo", "caja", "nautilus", "org.gnome.nautilus", "pcmanfm", "pcmanfm-qt", ]
    d["9"] = ["Evolution", "Geary", "Mail", "Thunderbird",
              "evolution", "geary", "mail", "thunderbird" ]
    d["0"] = ["Spotify", "Pragha", "Clementine", "Deadbeef", "Audacious",
              "spotify", "pragha", "clementine", "deadbeef", "audacious" ]
    ##########################################################
    wm_class = client.window.get_wm_class()[0]

    for i in range(len(d)):
        if wm_class in list(d.values())[i]:
            group = list(d.keys())[i]
            client.togroup(group)
            client.group.cmd_toscreen()

# END
# ASSIGN APPLICATIONS TO A SPECIFIC GROUPNAME


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
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # {'wmclass': 'Arcolinux-welcome-app.py'},
    # {'wmclass': 'Arcolinux-tweak-tool.py'},
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

],  fullscreen_border_width = border_width_, border_width = border_width_)
auto_fullscreen = True

focus_on_window_activation = "focus" # or smart

wmname = "LG3D"
