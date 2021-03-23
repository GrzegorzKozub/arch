#!/usr/bin/env zsh

set -e -o verbose

# dependencies

sudo pacman -S --noconfirm \
  archiso

paru -S --aur --noconfirm \
  preloader-signed

# config

ARCHISO=`dirname $0`/archiso
PROFILE=$ARCHISO/profile
ISO=$ARCHISO/iso
USB=$ARCHISO/usb
WORK=/tmp/archiso

# dirs

sudo rm -rf $ARCHISO
sudo rm -rf $WORK

mkdir -p $ARCHISO
mkdir -p $USB

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

sudo mkarchiso -v -L ARCHISO -w $WORK -o $ISO $PROFILE

# extract

sudo mount --read-only $(ls $ISO/*.iso) /mnt
cp -r /mnt/* $USB
sudo umount /mnt

# secure boot support

sudo chmod --recursive u+w $USB/EFI/BOOT
cp /usr/share/preloader-signed/{PreLoader,HashTool}.efi $USB/EFI/BOOT
mv $USB/EFI/BOOT/BOOTx64.EFI $USB/EFI/BOOT/loader.efi
mv $USB/EFI/BOOT/PreLoader.efi $USB/EFI/BOOT/BOOTx64.EFI

# cleanup

sudo pacman -Rs --noconfirm \
  archiso

paru -Rs --aur --noconfirm \
  preloader-signed

unset ARCHISO PROFILE ISO USB WORK

