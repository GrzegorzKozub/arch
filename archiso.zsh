#!/usr/bin/env zsh

set -e -o verbose

# build tools

sudo pacman -S --noconfirm \
  archiso

# config

BASE=`dirname $0`/archiso
PROFILE=$BASE/profile
OUT=$BASE/out
WORK=/tmp/archiso

# previous runs

[[ -d $BASE ]] || mkdir -p $BASE

sudo rm -rf $PROFILE
sudo rm -rf $OUT
sudo rm -rf $WORK

# profile

cp -r /usr/share/archiso/configs/releng $PROFILE

# loader

sed -i \
  -e 's/^\(options.*\)$/\1 video=1280x720/' \
  $PROFILE/efiboot/loader/entries/archiso-x86_64-linux.conf

# scripts

git clone https://github.com/GrzegorzKozub/arch.git $PROFILE/airootfs/root/arch

sed -i -e "/^)$/d" $PROFILE/profiledef.sh

for script in $(ls $PROFILE/airootfs/root/arch/*.*sh); do
  echo $script | sed -n -e "s/.*\/arch\(.*\)/  ['\/root\/arch\1']='0:0:755'/p" >> $PROFILE/profiledef.sh
done

echo ')' >> $PROFILE/profiledef.sh

# shell

cat << 'EOF' > $PROFILE/airootfs/root/.zshrc
typeset -U path && path=(~/arch $path[@])
unlock.zsh && mount.zsh
EOF

# build

sudo mkarchiso -v -w $WORK -o $OUT $PROFILE

# cleanup

unset PROFILE OUT WORK

