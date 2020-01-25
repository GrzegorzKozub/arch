set -e -o verbose

# chromium

sudo pacman -S --noconfirm chromium
yay -S --aur --noconfirm chromium-widevine

#cp `dirname $0`/home/greg/.config/chromium-flags.json ~/.config
