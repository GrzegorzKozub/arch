set -e -o verbose

# fix dropbox tray icon

cp ~/code/arch/home/greg/.dropbox-dist/dropbox-lnx.x86_64-VERSION/images/hicolor/16x16/status/*.png \
  ~/.dropbox-dist/dropbox-lnx.x86_64-$(cat ~/.dropbox-dist/VERSION)/images/hicolor/16x16/status
