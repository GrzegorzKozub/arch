set -e -o verbose

tar \
  -xf ~/code/arch/dropbox-fix.tar.gz \
  -C ~/.dropbox-dist/dropbox-lnx.x86_64-$(cat ~/.dropbox-dist/VERSION)/images/hicolor/16x16/status

dropbox-cli autostart n
