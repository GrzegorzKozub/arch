set -o verbose

bootctl --path=/boot install
cp `dirname $0`/boot/loader/loader.conf /boot/loader
cp `dirname $0`/boot/loader/entries/arch.conf /boot/loader/entries
sed -i "s/<uuid>/$(blkid -s UUID -o value /dev/nvme0n1p6)/g" /boot/loader/entries/arch.conf

cp ~/Arch/boot3.sh /home/greg
read -p "Run ~/boot3.sh and exit"
su greg
rm /home/greg/boot3.sh

cp /usr/share/preloader-signed/{PreLoader,HashTool}.efi /boot/EFI/systemd
cp /boot/EFI/systemd/systemd-bootx64.efi /boot/EFI/systemd/loader.efi
for BOOTNUM in $(efibootmgr | grep "Linux Boot Manager" | sed -E 's/^Boot(.+)\* Linux.*$/\1/g'); do
  efibootmgr --delete-bootnum --bootnum $BOOTNUM
done
efibootmgr --disk /dev/nvme0n1 --part 2 --create --label "Linux Boot Manager" --loader /EFI/systemd/PreLoader.efi
efibootmgr --bootorder $(efibootmgr | grep "Windows Boot Manager" | head -n1 | sed -E 's/^Boot(.+)\* Windows.*$/\1/g'),$(efibootmgr | grep "Linux Boot Manager" | sed -E 's/^Boot(.+)\* Linux.*$/\1/g')

