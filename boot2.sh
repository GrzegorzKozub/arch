set -e -o verbose

# boot manager

bootctl --path=/boot install

cp `dirname $0`/boot/loader/loader.conf /boot/loader
cp `dirname $0`/boot/loader/entries/arch.conf /boot/loader/entries
sed -i "s/<uuid>/$(blkid -s UUID -o value /dev/nvme0n1p7)/g" /boot/loader/entries/arch.conf

# secure boot support

cp `dirname $0`/boot3.sh /home/greg
su greg --command "~/boot3.sh"
rm /home/greg/boot3.sh

cp /usr/share/preloader-signed/{PreLoader,HashTool}.efi /boot/EFI/systemd
cp /boot/EFI/systemd/systemd-bootx64.efi /boot/EFI/systemd/loader.efi

# efi boot menu

for BOOTNUM in $(efibootmgr | grep "Linux Boot Manager" | sed -E 's/^Boot(.+)\* Linux.*$/\1/g'); do
  efibootmgr --delete-bootnum --bootnum $BOOTNUM
done

efibootmgr --disk /dev/nvme0n1 --part 2 --create --label "Linux Boot Manager" --loader /EFI/systemd/PreLoader.efi

WINDOWS=$(efibootmgr | grep "Windows Boot Manager" | head -n1 | sed -E 's/^Boot(.+)\* Windows Boot Manager$/\1/g')
LINUX=$(efibootmgr | grep "Linux Boot Manager" | sed -E 's/^Boot(.+)\* Linux Boot Manager$/\1/g')

efibootmgr --bootorder $WINDOWS,$LINUX

unset WINDOWS LINUX

