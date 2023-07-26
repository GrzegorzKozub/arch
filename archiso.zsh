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

# lts kernel

[[ $(grep 'linux-lts' $PROFILE/packages.x86_64) ]] || echo 'linux-lts' >> $PROFILE/packages.x86_64

# systemd-boot

# sed -i -e '/grub/d' $PROFILE/packages.x86_64

sed -i \
  -e "/^.*'uefi-ia32.grub.esp' 'uefi-x64.grub.esp'.*$/d" \
  $PROFILE/profiledef.sh

sed -i \
  -e "s/'uefi-ia32.grub.eltorito' 'uefi-x64.grub.eltorito'/'uefi-x64.systemd-boot.eltorito' 'uefi-x64.systemd-boot.esp'/" \
  $PROFILE/profiledef.sh

# config systemd-boot

cp $PROFILE/efiboot/loader/entries/01-archiso-x86_64-linux.conf \
  $PROFILE/efiboot/loader/entries/01-archiso.conf

cp $PROFILE/efiboot/loader/entries/01-archiso-x86_64-linux.conf \
  $PROFILE/efiboot/loader/entries/02-archiso-lts.conf

rm $PROFILE/efiboot/loader/entries/*archiso-x86_64*.conf

sed -i \
  -e 's/^title   .*$/title   Archiso/' \
  -e 's/archisodevice=UUID=%ARCHISO_UUID%/archisodevice=LABEL=ARCHISO/' \
  -e '/^options/ s/$/ nomodeset/' \
  $PROFILE/efiboot/loader/entries/01-archiso.conf

sed -i \
  -e 's/^title   .*$/title   Archiso LTS/' \
  -e 's/archisodevice=UUID=%ARCHISO_UUID%/archisodevice=LABEL=ARCHISO/' \
  -e '/^options/ s/$/ nomodeset/' \
  -e 's/vmlinuz-linux/vmlinuz-linux-lts/' \
  -e 's/initramfs-linux/initramfs-linux-lts/' \
  $PROFILE/efiboot/loader/entries/02-archiso-lts.conf

sed -i \
  -e 's/^timeout 15$/timeout 1/' \
  -e 's/^default.*$/default 01-archiso.conf/' \
  -e '/beep on/d' \
  $PROFILE/efiboot/loader/loader.conf

# scripts

git clone https://github.com/GrzegorzKozub/arch.git $PROFILE/airootfs/root/arch

sed -i -e "/^)$/d" $PROFILE/profiledef.sh

for script in $(ls $PROFILE/airootfs/root/arch/*.*sh); do
  echo $script | sed -n -e "s/.*\/arch\/\(.*\)/  ['\/root\/arch\/\1']='0:0:755'/p" >> $PROFILE/profiledef.sh
done

echo ')' >> $PROFILE/profiledef.sh

# shell

cat << 'EOF' > $PROFILE/airootfs/root/.zshrc
typeset -U path && path=(~/arch $path[@])
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

