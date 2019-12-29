set -e -o verbose

# dirs

if [ ! -d ~/Code ]; then mkdir ~/Code; fi

# scripts

if [ -d ~/Code/Arch ]; then rm -rf ~/Code/Arch; fi
git clone git@github.com:GrzegorzKozub/Arch.git ~/Code/Arch

