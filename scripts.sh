set -e -o verbose

# dirs

if [ ! -d ~/code ]; then mkdir ~/code; fi

# scripts

if [ -d ~/code/arch ]; then rm -rf ~/code/arch; fi
git clone git@github.com:GrzegorzKozub/arch.git ~/code/arch

cp -r ~/code/arch/home/greg/scripts ~
