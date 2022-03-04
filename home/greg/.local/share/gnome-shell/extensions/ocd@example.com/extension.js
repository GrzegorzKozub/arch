const ExtensionUtils = imports.misc.extensionUtils;
const Main = imports.ui.main;
const Meta = imports.gi.Meta;
const Shell = imports.gi.Shell;

class Extension {
  windowCreatedHandler;
  uhd;

  constructor() {}

  enable() {
    Main.wm.addKeybinding(
      'ocd',
      ExtensionUtils.getSettings('org.gnome.shell.extensions.ocd'),
      Meta.KeyBindingFlags.IGNORE_AUTOREPEAT,
      Shell.ActionMode.NORMAL | Shell.ActionMode.OVERVIEW,
      this.hotkeyPressed.bind(this));
    this.windowCreatedHandler = global.display.connect(
      'window-created',
      this.windowCreated);
    this.uhd = global.screen_width === 3840 && global.screen_height === 2160;
  }

  disable() {
    Main.wm.removeKeybinding('ocd');
    global.display.disconnect(this.windowCreatedHandler);
  }

  hotkeyPressed() {
    this.windows();
  }

  windowCreated(_, win) {}

  windows() {
    global.get_window_actors().forEach(win => {
      this.big(win.meta_window);
    });
  }

  big(win) {
    if (this.uhd) { this.center(win, 6, 14); } else { this.center(win, 7, 14.5); };
  }

  medium(win) {
    if (this.uhd) { this.center(win, 4.5, 12); } else { this.center(win, 6, 12.5); };
  }

  small(win) {
    if (this.uhd) { this.center(win, 3, 10); } else { this.center(win, 5, 10.5); };
  }

  center(win, width, height) {
    if (win.get_maximized()) {
      win.unmaximize(Meta.MaximizeFlags.BOTH);
    }
    const desktop = Main.layoutManager.getWorkAreaForMonitor(0);
    const widthStep = 8,
      heightStep = 16;
    win.move_resize_frame(
      0,
      ((desktop.width / widthStep) * ((widthStep - width) / 2)) + desktop.x,
      ((desktop.height / heightStep) * ((heightStep - height) / 2)) + desktop.y,
      (desktop.width / widthStep) * width,
      (desktop.height / heightStep) * height);
  }
}

function init() {
  return new Extension();
}

