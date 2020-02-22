set -e -o verbose

DIR=/mnt/$(date +%Y%m%d%H%M)
mkdir $DIR

fsarchiver savefs $DIR/root.fsa /dev/mapper/vg1-root
cp /mnt/boot/*.img /mnt/boot/vmlinuz-linux $DIR/

unset DIR

