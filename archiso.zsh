#!/usr/bin/env zsh

set -e -o verbose

# config

DIR=`dirname $0`/archiso
WORK=/tmp/archiso

# previous runs

sudo rm -rf $DIR
sudo rm -rf $WORK

# profile

cp -r /usr/share/archiso/configs/releng $DIR

# packages

echo git >> $DIR/packages.x86_64

# loader

sed -i \
  -e 's/^\(options.*\)$/\1 video=1280x720/' \
  $DIR/efiboot/loader/entries/archiso-x86_64-linux.conf

# scripts

git clone https://github.com/GrzegorzKozub/arch.git $DIR/airootfs/root/arch

sed -i -e "/^)$/d" $DIR/profiledef.sh

for script in $(ls $DIR/airootfs/root/arch/*.*sh); do
  echo "  ['$script']='0:0:755'" | sed -n -e "s/\.\/archiso\/airootfs//p" >> $DIR/profiledef.sh
done

echo ')' >> $DIR/profiledef.sh

# profile

cat << 'EOF' > $DIR/airootfs/root/.zshrc
typeset -U path && path=(~/arch $path[@])
unlock.zsh && mount.zsh
EOF

# build

sudo mkarchiso -v -w $WORK -o $DIR $DIR

# cleanup

unset DIR WORK

