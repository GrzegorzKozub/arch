set -e -o verbose

# validation

[[ $MY_ARCH_PART && $(lsblk -lno PATH,PARTTYPE | grep -i '0FC63DAF-8483-4772-8E79-3D69D8477DE4' | cut -d' ' -f1) == $MY_ARCH_PART ]] || exit 1

# unlock

cryptsetup luksOpen $MY_ARCH_PART lvm
sleep 1

