#!/usr/bin/env zsh

set -e -o verbose

# dependencies

sudo pacman -S --noconfirm \
  archiso

paru -S --aur --noconfirm \
  preloader-signed

# config

WORK=/tmp/archiso
ARCHISO=`dirname $0`/archiso

PROFILE=$ARCHISO/profile
UUID=1234-5678 # archisosearchuuid

ISO=$ARCHISO/iso
USB=$ARCHISO/usb
ESP=/boot/archiso

# dirs

sudo rm -rf $WORK
sudo rm -rf $ARCHISO

mkdir -p $ARCHISO
mkdir -p $USB

# profile

cp -r /usr/share/archiso/configs/releng $PROFILE

# packages

for PACKAGE in \
  linux-lts \
  neovim
do
  [[ $(grep $PACKAGE $PROFILE/packages.x86_64) ]] || echo $PACKAGE >> $PROFILE/packages.x86_64
done

# systemd-boot

sed -i \
  -e "/^.*'uefi-ia32.grub.esp' 'uefi-x64.grub.esp'.*$/d" \
  $PROFILE/profiledef.sh

sed -i \
  -e "s/'uefi-ia32.grub.eltorito' 'uefi-x64.grub.eltorito'/'uefi-x64.systemd-boot.eltorito' 'uefi-x64.systemd-boot.esp'/" \
  $PROFILE/profiledef.sh

cp $PROFILE/efiboot/loader/entries/01-archiso-linux.conf \
  $PROFILE/efiboot/loader/entries/archiso.conf

cp $PROFILE/efiboot/loader/entries/01-archiso-linux.conf \
  $PROFILE/efiboot/loader/entries/archiso-lts.conf

rm $PROFILE/efiboot/loader/entries/*archiso-{linux,memtest,speech}*.conf

sed -i \
  -e 's/^title.*$/title    Archiso/' \
  -e 's/^sort-key.*$/sort-key 01/' \
  -e "s/\(archisosearchuuid=\)[^ ]*/\1$UUID/" \
  $PROFILE/efiboot/loader/entries/archiso.conf

sed -i \
  -e 's/^title.*$/title    Archiso LTS/' \
  -e 's/^sort-key.*$/sort-key 02/' \
  -e 's/vmlinuz-linux/vmlinuz-linux-lts/' \
  -e 's/initramfs-linux/initramfs-linux-lts/' \
  -e "s/\(archisosearchuuid=\)[^ ]*/\1$UUID/" \
  $PROFILE/efiboot/loader/entries/archiso-lts.conf

sed -i \
  -e 's/^timeout 15$/timeout 1/' \
  -e 's/^default.*$/default archiso.conf/' \
  -e '/beep on/d' \
  $PROFILE/efiboot/loader/loader.conf

# console

echo 'FONT=ter-232b' >> $PROFILE/airootfs/etc/vconsole.conf

# scripts

git clone https://github.com/GrzegorzKozub/arch.git $PROFILE/airootfs/root/arch

sed -i -e "/^)$/d" $PROFILE/profiledef.sh

for SCRIPT in "$PROFILE"/airootfs/root/arch/*.*sh; do
  echo $SCRIPT | sed -n -e "s/.*\/arch\/\(.*\)/  ['\/root\/arch\/\1']='0:0:755'/p" >> $PROFILE/profiledef.sh
done

echo ')' >> $PROFILE/profiledef.sh

# dotfiles

cat << 'EOF' > $PROFILE/airootfs/root/.zshrc
typeset -U path
path=(~/arch $path[@])

export EDITOR='nvim'
export DIFFPROG='nvim -d'
export VISUAL='nvim'

alias v='nvim'
alias vim='nvim'

alias b='b.zsh'
alias r='r.zsh'
EOF

# build

sudo mkarchiso -v -L ARCHISO -w $WORK -o $ISO $PROFILE

# extract

sudo mount --read-only $(ls $ISO/*.iso) /mnt
cp -r /mnt/* $USB
sudo umount /mnt

# archisosearchfilename

sudo mv $USB/boot/*.uuid $USB/boot/$UUID.uuid

# systemd-boot secure boot support using preloader

sudo chmod --recursive u+w $USB/EFI/BOOT
cp /usr/share/preloader-signed/{HashTool,PreLoader}.efi $USB/EFI/BOOT
mv $USB/EFI/BOOT/BOOTx64.EFI $USB/EFI/BOOT/loader.efi
mv $USB/EFI/BOOT/PreLoader.efi $USB/EFI/BOOT/BOOTx64.EFI

# update on esp

sudo [ -d $ESP ] && sudo rm -rf $ESP
sudo mkdir $ESP

sudo cp -r $USB/arch/boot/x86_64/* $ESP
sudo cp -r $USB/arch/x86_64 $ESP

if [[ $(sudo sbctl status --json | jq .installed) == 'true' ]]; then

  for FILE in \
    vmlinuz-linux \
    vmlinuz-linux-lts
  do
    sudo sbctl sign --save /boot/archiso/$FILE
  done

fi

# update on pendrive

if [ -d /run/media/$USER/ARCHISO ]; then

  rm -rf /run/media/$USER/ARCHISO/(arch|boot|EFI|loader|shellia32.efi|shellx64.efi)
  cp -r $USB/* /run/media/$USER/ARCHISO

fi

# cleanup

sudo pacman -Rs --noconfirm \
  archiso

paru -Rs --aur --noconfirm \
  preloader-signed

