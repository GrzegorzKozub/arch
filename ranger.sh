set -e -o verbose

# ranger

sudo pacman -S --noconfirm ranger

#if [ ! -d ~/.config/ranger ]; then mkdir ~/.config/ranger; fi

#cp `dirname $0`/home/greg/.config/ranger/rc.conf ~/.config/ranger

#if [ -d ~/ranger_devicons ]; then rm -rf ~/ranger_devicons; fi
#pushd ~
#git clone https://github.com/alexanderjeurissen/ranger_devicons
#cd ranger_devicons
#make install
#popd
#rm -rf ~/ranger_devicons
