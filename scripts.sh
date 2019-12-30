set -e -o verbose

# dirs

if [ ! -d ~/Code ]; then mkdir ~/Code; fi

# scripts

if [ -d ~/Code/arch ]; then rm -rf ~/Code/arch; fi
git clone git@github.com:GrzegorzKozub/arch.git ~/Code/arch

