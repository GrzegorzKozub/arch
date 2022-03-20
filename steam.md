1. Enable multilib repo in `/etc/pacman.conf`
2. Install steam:
  ```
  sudo pacman -Sy
  sudo pacman -S --noconfirm steam
  ```
3. Install and enable gamemode:
  ```
  sudo pacman -S --noconfirm gamemode lib32-gamemode
  systemctl --user enable gamemoded.service
  systemctl --user start gamemoded.service
  ```
4. Install mangohud
  ```
  paru -S --aur --noconfirm mangohud lib32-mangohud
  ```
5. Start steam and select proton experimental with bleeding-edge beta
6. Add mangohud and gamemode to game launch options
  ```
  mangohud gamemoderun %command%
  ```
7. Check reports on https://www.protondb.com/
8. Fix the disk write errors for ntfs steam library
  ```
  rm -rf ~/.steam/steam/steamapps/compatdata /mnt/SteamLibrary/steamapps/compatdata
  mkdir -p ~/.steam/steam/steamapps/compatdata
  ln -s ~/.steam/steam/steamapps/compatdata /mnt/SteamLibrary/steamapps/compatdata
  ```

