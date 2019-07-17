set -e -o verbose

# unlock

cryptsetup luksOpen /dev/nvme0n1p7 lvm

