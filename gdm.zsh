#!/usr/bin/env zsh

set -e -o verbose

# reset

sudo pacman -S --noconfirm \
  gnome-shell

# dconf

cat <<EOF | sudo tee /etc/dconf/profile/gdm
user-db:user
system-db:gdm
file-db:/usr/share/gdm/greeter-dconf-defaults
EOF

DIR=/etc/dconf/db/gdm.d
[[ -d $DIR ]] || sudo mkdir -p $DIR

cat <<EOF | sudo tee $DIR/10-gdm
[org/gnome/settings-daemon/plugins/color]
night-light-enabled=true
night-light-schedule-automatic=true

[org/gnome/settings-daemon/plugins/power]
power-button-action='interactive'
sleep-inactive-ac-timeout=3600
sleep-inactive-battery-timeout=600

[org/gnome/desktop/sound]
event-sounds=false

[org/gnome/desktop/interface]
font-antialiasing='rgba'
icon-theme='Papirus'
EOF

[[ $HOST = 'drifter' ]] && cat <<EOF | sudo tee --append $DIR/10-gdm

[org/gnome/desktop/session]
idle-delay=300

[org/gnome/desktop/peripherals/touchpad]
speed=0.25
tap-to-click=true
EOF

[[ $HOST =~ ^(player|worker)$ ]] && cat <<EOF | sudo tee --append $DIR/10-gdm

[org/gnome/desktop/session]
idle-delay=600

[org/gnome/desktop/peripherals/mouse]
speed=-0.75
EOF

sudo dconf update

# displays

SOURCE=`dirname $0`/home/$USER/.config/monitors.$HOST.xml
TARGET=/var/lib/gdm/seat0/config/monitors.xml

[[ -f $SOURCE ]] &&
  sudo cp $SOURCE $TARGET &&
  sudo sed -i '/ratemode/d' $TARGET

# display scale factor

SCHEMAS=/usr/share/glib-2.0/schemas
OVERRIDE=10_screen-scale.gschema.override

[[ $HOST = 'drifter' ]] && FACTOR=3 || FACTOR=2

echo '[org.gnome.desktop.interface]' | sudo tee $SCHEMAS/$OVERRIDE > /dev/null
echo "scaling-factor=$FACTOR" | sudo tee --append $SCHEMAS/$OVERRIDE > /dev/null

sudo glib-compile-schemas $SCHEMAS

# wallpaper

GS=/usr/share/gnome-shell
GST=gnome-shell-theme.gresource
TMP="$(mktemp -d)"

mkdir -p $TMP/theme/icons/scalable/actions
mkdir -p $TMP/theme/icons/scalable/status
cp ~/code/walls/women.jpg $TMP/theme/

for RES in `gresource list $GS/$GST`; do
  gresource extract $GS/$GST $RES > $TMP/${RES#\/org\/gnome\/shell/}
done

cat <<EOF > $TMP/theme/$GST.xml
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">
EOF

for RES in `find $TMP/theme -type f -not -name '*.xml'`; do
  echo "    <file>${RES/$TMP\/theme\//}</file>" >> $TMP/theme/$GST.xml
done

cat <<EOF >> $TMP/theme/$GST.xml
  </gresource>
</gresources>
EOF

[[ $HOST =~ ^(drifter|player)$ ]] && cat <<EOF >> $TMP/theme/gnome-shell-dark.css
#lockDialogGroup {
  background: url(resource:///org/gnome/shell/theme/women.jpg);
  background-repeat: no-repeat;
  background-size: cover;
}
.login-dialog {
  background-color: rgba(0, 0, 0, 0.5);
}
EOF

[[ $HOST = 'worker' ]] && cat <<EOF >> $TMP/theme/gnome-shell-dark.css
#lockDialogGroup {
  background: url(resource:///org/gnome/shell/theme/women.jpg);
  background-position: 0 0;
  background-repeat: repeat;
  background-size: 1920px 1263px;
}
.login-dialog {
  background-color: rgba(0, 0, 0, 0.5);
}
EOF

pushd $TMP/theme
glib-compile-resources $GST.xml
popd

sudo cp $TMP/theme/$GST $GS/$GST

