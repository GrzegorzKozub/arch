// https://gjs.guide/extensions/

const ExtensionUtils = imports.misc.extensionUtils;
const Main = imports.ui.main;
const Meta = imports.gi.Meta;
const Shell = imports.gi.Shell;

class Extension {
  constructor() {}

  enable() {
    const settings = ExtensionUtils.getSettings('org.gnome.shell.extensions.ocd');
    Main.wm.addKeybinding(
      'ocd',
      settings,
      Meta.KeyBindingFlags.IGNORE_AUTOREPEAT,
      Shell.ActionMode.NORMAL | Shell.ActionMode.OVERVIEW,
      this.windows.bind(this));
  }

  disable() {
    Main.wm.removeKeybinding('ocd');
  }

  windows() {
    global.get_window_actors().forEach(win => {
      log(win.meta_window.title);
    });
  }
}

function init() {
  return new Extension();
}
