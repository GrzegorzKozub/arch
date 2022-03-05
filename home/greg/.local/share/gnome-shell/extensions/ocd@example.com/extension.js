/* eslint-disable no-undef */

const ExtensionUtils = imports.misc.extensionUtils;
const Main = imports.ui.main;
const Meta = imports.gi.Meta;
const Shell = imports.gi.Shell;

class Extension {
  uhd;
  windowCreatedHandler;

  config = [
    { title: /.?Azure Data Studio$/, big: true },
    { title: /.?Brave$/, big: true, auto: true },
    { title: /.?MySQL Workbench$/, big: true },
    { title: /^OBS.?/, big: true },
    { title: /^Postman$/, big: true, auto: true },
    { title: /.?Shotcut$/, big: true },
    { title: /.?Visual Studio Code$/, big: true },

    { class: /.?Foliate$/, medium: true },
    { title: /.?GIMP$/, medium: true },
    { title: /^GNU Image Manipulation Program$/, medium: true },
    { title: /.?Slack$/, medium: true, auto: true },

    { title: /.?KeePassXC$/, small: true },
    { title: /.?Pinta$/, medium: true },
  ];

  constructor() {}

  enable() {
    this.uhd = global.screen_width === 3840 && global.screen_height === 2160;
    this.windowCreatedHandler = global.display.connect(
      'window-created',
      this.windowCreated.bind(this));
    Main.wm.addKeybinding(
      'ocd',
      ExtensionUtils.getSettings('org.gnome.shell.extensions.ocd'),
      Meta.KeyBindingFlags.IGNORE_AUTOREPEAT,
      Shell.ActionMode.NORMAL | Shell.ActionMode.OVERVIEW,
      this.hotkeyPressed.bind(this));
  }

  disable() {
    global.display.disconnect(this.windowCreatedHandler);
    Main.wm.removeKeybinding('ocd');
  }

  windowCreated(_, win) { this.fixAuto(win); }
  hotkeyPressed() { this.fixAll(); }

  fixAuto(win) {
    this.fix(this.config.filter(cfg => cfg.auto), win);
  }

  fixAll() {
    global.get_window_actors().forEach(actor => this.fix(this.config, actor.meta_window));
  }

  fix(config, win) {
    const cfg = config.find(cfg =>
      cfg.title && cfg.title.test(win.title) ||
      cfg.class && cfg.class.test(win.wm_class));
    if (!cfg) { return; }
    this.unmax(win);
    if (cfg.big) { this.big(win); }
    else if (cfg.medium) { this.medium(win); }
    else if (cfg.small) { this.small(win); }
  }

  unmax(win) { if (win.get_maximized()) { win.unmaximize(Meta.MaximizeFlags.BOTH); } }

  big(win) { if (this.uhd) { this.center(win, 6, 14); } else { this.center(win, 7, 14.5); } }
  medium(win) { if (this.uhd) { this.center(win, 4.5, 12); } else { this.center(win, 6, 12.5); } }
  small(win) { if (this.uhd) { this.center(win, 3, 10); } else { this.center(win, 5, 10.5); } }

  center(win, width, height) {
    const desktop = Main.layoutManager.getWorkAreaForMonitor(0);
    const widthStep = 8, heightStep = 16;
    win.move_resize_frame(
      0,
      ((desktop.width / widthStep) * ((widthStep - width) / 2)) + desktop.x,
      ((desktop.height / heightStep) * ((heightStep - height) / 2)) + desktop.y,
      (desktop.width / widthStep) * width,
      (desktop.height / heightStep) * height);
  }
}

// eslint-disable-next-line no-unused-vars
const init = () => new Extension();

