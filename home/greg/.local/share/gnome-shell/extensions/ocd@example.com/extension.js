const ExtensionUtils = imports.misc.extensionUtils;
const Main = imports.ui.main;
const Meta = imports.gi.Meta;
const Shell = imports.gi.Shell;
const GLib = imports.gi.GLib;
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
      this.center(win.meta_window, 7, 12);
    });
    //log(this.getScreen().laptop);

  }

  center(win, w, h) {
    if (win.get_maximized()) { win.unmaximize(3); }
    const widthStep = 8, heightStep = 16;
    const ws = Main.layoutManager.getWorkAreaForMonitor(0) 
    win.move_resize_frame(
      0,
      ws.x + (ws.width / widthStep * (widthStep - w) / 2),
      ws.y + (ws.height / heightStep * (heightStep - h) / 2),
      ws.width / widthStep * w,
      ws.height / heightStep * h
    );

    // Maximization needs to be delayed a little, so that the window has time to move
    //
    // Meta.MaximizeFlags
            GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, function() { win.maximize(3); });
  }

  //getConfig() {
    //return [
      //{ app: 'brave', }
    //];
  //}

  //getScreen() {
    //const screen = {};
    //if (global.screen_width === 3840 && global.screen_height === 2160) {
      //screen.monitor = true;
    //} else if (global.screen_width === 3840 && global.screen_height === 2400) {
      //screen.monitor = false;
    //}
    //return screen;
  //}
}

function init() {
  return new Extension();
}
