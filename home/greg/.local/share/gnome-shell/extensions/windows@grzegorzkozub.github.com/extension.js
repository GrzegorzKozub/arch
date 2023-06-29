/* eslint-disable no-undef */

const ExtensionUtils = imports.misc.extensionUtils;
const GLib = imports.gi.GLib;
const Main = imports.ui.main;
const Meta = imports.gi.Meta;
const Shell = imports.gi.Shell;

class Extension {
  windowCreatedHandler;
  config = [];

  constructor() {
    const big = [
      { title: /.?Azure Data Studio$/ },
      { title: /.?Brave$/, noRole: 'pop-up' },
      { title: /.?MySQL Workbench$/ },
      { title: /^OBS.?/ },
      { class: /^Postman$/, auto: true },
      { title: /.?Shotcut$/ },
      { title: /.?Visual Studio Code$/ },
    ];
    const medium = [
      { title: /^Cemu.?/ },
      { title: /^DevTools.?/ },
      { title: /.?GIMP$/ },
      { title: /^GNU Image Manipulation Program$/ },
      { title: /.?LibreOffice.?/ },
      { title: /.?Slack$/, auto: true },
      { title: /.?Steam$/ },
    ];
    const small = [
      { class: /.?drawing.?/ },
      { class: /.?Evince$/, auto: true },
      { title: /^Settings$/ },
      { title: /.?KeePassXC$/ },
    ];
    const addConfig = (config, fix) => {
      this.config.push(...config.map(cfg => ({ ...cfg, fix })));
    };
    addConfig(big, this.big.bind(this));
    addConfig(medium, this.medium.bind(this));
    addConfig(small, this.small.bind(this));
  }

  enable() {
    this.windowCreatedHandler = global.display.connect(
      'window-created',
      this.windowCreated.bind(this));
    this.addKeybinding('fix-all', this.fixAllHotkeyPressed);
    this.addKeybinding('fix-active', this.fixActiveHotkeyPressed);
    this.addKeybinding('tile-left', this.tileLeftHotkeyPressed);
    this.addKeybinding('tile-right', this.tileRightHotkeyPressed);
  }

  disable() {
    global.display.disconnect(this.windowCreatedHandler);
    Main.wm.removeKeybinding('windows');
  }

  addKeybinding(name, handler) {
    Main.wm.addKeybinding(
      name,
      ExtensionUtils.getSettings('org.gnome.shell.extensions.windows'),
      Meta.KeyBindingFlags.IGNORE_AUTOREPEAT,
      Shell.ActionMode.NORMAL | Shell.ActionMode.OVERVIEW,
      handler.bind(this));
  }

  windowCreated(_, win) { this.fixAuto(win); }
  fixAllHotkeyPressed() { this.fixAll(); }
  fixActiveHotkeyPressed() { this.fixActive(); }
  tileLeftHotkeyPressed() { this.tileLeft(); }
  tileRightHotkeyPressed() { this.tileRight(); }

  fixAuto(win) {
    GLib.timeout_add(GLib.PRIORITY_DEFAULT, 500, () => {
      this.fix(this.config.filter(cfg => cfg.auto), win);
      this.activate(win);
      return GLib.SOURCE_REMOVE;
    });
  }

  fixAll() {
    global.get_window_actors().forEach(actor => this.fix(this.config, actor.meta_window));
  }

  fixActive() {
    const win = global.display.get_focus_window();
    if (win) { this.fix(this.config, win); }
  }

  fix(config, win) {
    const cfg = config.find(cfg =>
      (cfg.title && cfg.title.test(win.title) || cfg.class && cfg.class.test(win.wm_class)) &&
      (!cfg.noRole || cfg.noRole !== win.get_role()));
    if (!cfg) { return; }
    cfg.fix(win);
  }

  big(win) { if (this.uhd()) { this.center(win, 12, 14); } else { this.center(win, 14, 14.5); } }
  medium(win) { if (this.uhd()) { this.center(win, 9, 12); } else { this.center(win, 12, 12.5); } }
  small(win) { if (this.uhd()) { this.center(win, 6, 10); } else { this.center(win, 10, 10.5); } }

  activate(win) {
    // https://gitlab.gnome.org/GNOME/mutter/-/issues/2690
    // if (!Meta.is_wayland_compositor()) { return; }
    const now = global.get_current_time(); const workspace = win.get_workspace();
    if (workspace) { workspace.activate_with_focus(win, now); } else { win.activate(now); }
  }

  center(win, width, height) {
    const desktop = this.getDesktop();
    const step = 16;
    this.move(
      win,
      ((desktop.width / step) * ((step - width) / 2)) + desktop.x,
      ((desktop.height / step) * ((step - height) / 2)) + desktop.y,
      (desktop.width / step) * width,
      (desktop.height / step) * height);
  }

  async move(win, x, y, width, height) {
    await this.unmax(win);
    this.animate(win);
    win.move_resize_frame(true, x, y, width, height);
  }

  unmax(win) {
    return new Promise(resolve => {
      const max = win.get_maximized();
      if (max) {
        win.unmaximize(max);
        GLib.timeout_add(GLib.PRIORITY_DEFAULT, 250, () => { resolve(); return GLib.SOURCE_REMOVE; });
      } else { resolve(); }
    });
  }

  animate(win) {
    const compositor = win.get_compositor_private();
    compositor.remove_all_transitions();
    Main.wm._prepareAnimationInfo(
      global.window_manager,
      compositor,
      win.get_frame_rect().copy(),
      Meta.SizeChange.MAXIMIZE);
  }

  uhd() { const monitor = this.getMonitor(); return monitor.width === 3840 && monitor.height === 2160; }

  tileLeft() {
    const win = global.display.get_focus_window();
    const desktop = this.getDesktop();
    const gap = 20;
    this.move(
      win,
      desktop.x + gap,
      desktop.y + gap,
      (desktop.width / 2) - (gap * 1.5),
      (desktop.height) - (gap * 2));
  }

  tileRight() {
    const win = global.display.get_focus_window();
    const desktop = this.getDesktop();
    const gap = 20;
    this.move(
      win,
      (desktop.width / 2) + desktop.x + (gap / 2),
      desktop.y + gap,
      (desktop.width / 2) - (gap * 1.5),
      (desktop.height) - (gap * 2));
  }
  getMonitor() { return global.display.get_monitor_geometry(global.display.get_primary_monitor()); }
  getDesktop() { return Main.layoutManager.getWorkAreaForMonitor(global.display.get_primary_monitor()); }
}

// eslint-disable-next-line no-unused-vars
var init = () => new Extension();

