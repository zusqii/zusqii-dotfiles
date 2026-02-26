# fulldock — Three-Island Floating Waybar

A modular, Pywal-aware Waybar config for EndeavourOS + Hyprland.

## Structure

```
~/.config/waybar/fulldock/
├── config.jsonc       ← Main bar config (heavily commented)
├── style.css          ← Styling: three floating pills + Pywal vars
├── launch.sh          ← Helper: kill old bar and launch this one
└── scripts/
    └── cava.sh        ← Audio visualizer pipe (requires: cava)
```

## Layout

```
[ 󰣇 · 1 2 3 4 5 6 · 09:41 ]          [  Song · ▄▆█▃ | ■ Window Title | 󰤨 󰂯 󰾅 ]          [ 󰻠 12% 󰍛 34% 󰁾 91% · ⏻ ]
       LEFT ISLAND                              CENTER DOCK                                      RIGHT ISLAND
```

## Dependencies

| Package              | Purpose                    | Install (EndeavourOS)       |
|----------------------|----------------------------|-----------------------------|
| `waybar`             | Bar itself                 | `sudo pacman -S waybar`     |
| `cava`               | Audio visualizer           | `sudo pacman -S cava`       |
| `playerctl`          | MPRIS media info           | `sudo pacman -S playerctl`  |
| `rofi`               | App launcher               | `sudo pacman -S rofi`       |
| `blueman`            | Bluetooth manager GUI      | `sudo pacman -S blueman`    |
| `nm-connection-editor`| Network manager GUI       | `sudo pacman -S nm-connection-editor` |
| `wlogout`            | Power menu                 | `paru -S wlogout`           |
| `pywal` / `wal`      | Dynamic color theming      | `sudo pacman -S python-pywal` |
| JetBrainsMono NF     | Nerd Font (icons + text)   | `paru -S ttf-jetbrains-mono-nerd` |
| `power-profiles-daemon` | Power profile switching | `sudo pacman -S power-profiles-daemon` |

Enable power profiles daemon:
```bash
sudo systemctl enable --now power-profiles-daemon
```

## Setup

### 1. Copy files to config directory

```bash
mkdir -p ~/.config/waybar/fulldock/scripts
cp config.jsonc style.css launch.sh ~/.config/waybar/fulldock/
cp scripts/cava.sh ~/.config/waybar/fulldock/scripts/
chmod +x ~/.config/waybar/fulldock/launch.sh
chmod +x ~/.config/waybar/fulldock/scripts/cava.sh
```

### 2. Fix the Pywal import in style.css

Open `style.css` and update line 10 with your actual username:

```css
@import url("/home/YOUR_USERNAME/.cache/wal/colors-waybar.css");
```

Or use the symlink approach (more portable):

```bash
ln -sf ~/.cache/wal/colors-waybar.css ~/.config/waybar/fulldock/colors.css
```

Then in `style.css` change the import to:

```css
@import url("./colors.css");
```

### 3. Launch from Hyprland config

In `~/.config/hypr/hyprland.conf`:

```ini
exec-once = ~/.config/waybar/fulldock/launch.sh
```

Or to reload on the fly:

```bash
~/.config/waybar/fulldock/launch.sh
```

## Customization Tips

- **Colors**: All colors come from Pywal. Run `wal -i your-wallpaper.jpg` to regenerate.
- **Pill opacity**: Edit `--bg-opacity` in `style.css` under CSS VARIABLES.
- **Bar height**: Change `"height": 36` in `config.jsonc`.
- **Margins**: `margin-top: 8` controls gap from screen top. Increase for more float.
- **Workspaces**: Add/remove persistent workspace IDs in `hyprland/workspaces`.
- **Cava bars**: Change the `10` arg in `custom/cava` exec to adjust bar count.
