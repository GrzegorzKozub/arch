#!/usr/bin/env zsh

set -e -o verbose

# tap to click

sudo machinectl shell gdm@ /bin/bash -c "gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click 'true'"

# fonts

if [[ $HOST = 'ampere' || $HOST = 'turing' ]]; then
  sudo machinectl shell gdm@ /bin/bash -c 'gsettings set org.gnome.desktop.interface text-scaling-factor 1.5'
fi

# background image

GS=/usr/share/gnome-shell
GST=gnome-shell-theme.gresource
TMP="$(mktemp -d)"

sudo cp -n $GS/$GST $GS/$GST.backup
mkdir -p $TMP/theme/icons/scalable/actions
mkdir -p $TMP/theme/icons/scalable/status
cp `dirname $0`/home/greg/Pictures/women.jpg $TMP/theme/

for RES in `gresource list $GS/$GST`; do
  gresource extract $GS/$GST $RES > $TMP/${RES#\/org\/gnome\/shell/}
done

cat <<EOF > $TMP/theme/$GST.xml
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">
EOF

for RES in `find $TMP/theme -type f`; do
  echo "    <file>${RES/$TMP\/theme\//}</file>" >> $TMP/theme/$GST.xml
done

cat <<EOF >> $TMP/theme/$GST.xml
  </gresource>
</gresources>
EOF

cat <<EOF >> $TMP/theme/gnome-shell.css
#lockDialogGroup {
  background: url(resource:///org/gnome/shell/theme/women.jpg);
  background-size: cover;
  background-repeat: no-repeat;
}
EOF

pushd $TMP/theme
glib-compile-resources $GST.xml
popd

sudo cp $TMP/theme/$GST $GS/$GST

unset GS GST TMP

