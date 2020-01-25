set -e -o verbose

# dirs

if [ ! -d ~/code ]; then mkdir ~/code; fi

# scripts

if [ -d ~/code/arch ]; then rm -rf ~/code/arch; fi
git clone git@github.com:GrzegorzKozub/arch.git ~/code/arch

if [ -d ~/code/themes ]; then rm -rf ~/code/themes; fi
git clone git@github.com:GrzegorzKozub/themes.git ~/code/themes
