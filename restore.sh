set -e -o verbose

if [[ ! -d $1 ]]; then exit 1; fi

fsarchiver restfs $1/root.fsa id=0,dest=/dev/mapper/vg1-root
cp $1/*.img $1/vmlinuz-linux /mnt/boot/

