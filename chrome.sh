set -e -o verbose

# chrome

yay -S --aur --noconfirm google-chrome

cp `dirname $0`/home/greg/.config/chromium-flags.json ~/.config
