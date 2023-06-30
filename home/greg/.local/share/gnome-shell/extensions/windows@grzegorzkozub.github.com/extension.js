/* eslint-disable no-undef */

const ExtensionUtils = imports.misc.extensionUtils;
const GLib = imports.gi.GLib;
const Main = imports.ui.main;
const Meta = imports.gi.Meta;
const Shell = imports.gi.Shell;

class Extension {
  windowCreatedHandler;
  config = [];
  step = 16;
  gap = 20;

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
    this.addKeybinding('tile-down', this.tileDownHotkeyPressed);
    this.addKeybinding('tile-up', this.tileUpHotkeyPressed);
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
  tileDownHotkeyPressed() { this.tileDown(); }
  tileUpHotkeyPressed() { this.tileUp(); }
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
    const win = this.getWindow();
    if (win) { this.fix(this.config, win); }
  }

  fix(config, win) {
    const cfg = config.find(cfg =>
      (cfg.title && cfg.title.test(win.title) || cfg.class && cfg.class.test(win.wm_class)) &&
      (!cfg.noRole || cfg.noRole !== win.get_role()));
    if (!cfg) { return; }
    cfg.fix(win);
  }

  activate(win) {
    // https://gitlab.gnome.org/GNOME/mutter/-/issues/2690
    // if (!Meta.is_wayland_compositor()) { return; }
    const now = global.get_current_time(); const workspace = win.get_workspace();
    if (workspace) { workspace.activate_with_focus(win, now); } else { win.activate(now); }
  }

  big(win) { if (this.onUhd(win)) { this.center(win, 12, 14); } else { this.center(win, 14, 14.5); } }
  medium(win) { if (this.onUhd(win)) { this.center(win, 9, 12); } else { this.center(win, 12, 12.5); } }
  small(win) { if (this.onUhd(win)) { this.center(win, 6, 10); } else { this.center(win, 10, 10.5); } }

  onUhd(win) { const monitor = this.getMonitor(win); return monitor.width === 3840 && monitor.height === 2160; }

  center(win, width, height) { this.move(win, this.getCenterTile(win, width, height)); }

  tileLeft() {
    const win = this.getWindow();
    const now = this.getCurrentTile(win);
    const down = this.getDownTile(win);
    const up = this.getUpTile(win);
    const left = this.getLeftTile(win);
    const downLeft = this.getDownLeftTile(win);
    const upLeft = this.getUpLeftTile(win);
    if (now.equal(down)) { this.move(win, downLeft); return; }
    if (now.equal(up)) { this.move(win, upLeft); return; }
    if (now.equal(left) || now.equal(downLeft) || now.equal(upLeft)) { return; }
    this.move(win, left);
  }

  tileDown() {
    const win = this.getWindow();
    const now = this.getCurrentTile(win);
    const down = this.getDownTile(win);
    const up = this.getUpTile(win);
    const left = this.getLeftTile(win);
    const downLeft = this.getDownLeftTile(win);
    const upLeft = this.getUpLeftTile(win);
    if (now.equal(left)) { this.move(win, downLeft); return; }
    if (now.equal(down) || now.equal(downLeft)) { return; }
    if (now.equal(upLeft)) { this.move(win, left); return; }
    this.move(win, down);
  }

  tileUp() {
    const win = this.getWindow();
    const now = this.getCurrentTile(win);
    const down = this.getDownTile(win);
    const up = this.getUpTile(win);
    const left = this.getLeftTile(win);
    const downLeft = this.getDownLeftTile(win);
    const upLeft = this.getUpLeftTile(win);
    if (now.equal(down)) { this.move(win, up); return; }
    if (now.equal(left)) { this.move(win, upLeft); return; }
    if (now.equal(downLeft)) { this.move(win, left); return; }
    if (now.equal(up) || now.equal(upLeft)) { return; }
    this.move(win, up);
  }

  tileRight() { }

  getCurrentTile(win) {
    const tile = win.get_frame_rect();
    if (/.?KeePassXC$/.test(win.title)) { tile.width++; }
    return tile;
  }

  getCenterTile(win, width, height) {
    const desktop = this.getDesktop(win);
    const tile = new Meta.Rectangle();
    tile.x = ((desktop.width / this.step) * ((this.step - width) / 2)) + desktop.x;
    tile.y = ((desktop.height / this.step) * ((this.step - height) / 2)) + desktop.y;
    tile.width = (desktop.width / this.step) * width;
    tile.height = (desktop.height / this.step) * height;
    return tile;
  }

  getDownTile(win) {
    const desktop = this.getDesktop(win);
    const tile = new Meta.Rectangle();
    tile.x = desktop.x + this.gap;
    tile.y = desktop.y + (desktop.height / 2) + (this.gap * 0.5);
    tile.width = desktop.width - (this.gap * 2);
    tile.height = (desktop.height / 2) - (this.gap * 1.5);
    return tile;
  }

  getUpTile(win) {
    const desktop = this.getDesktop(win);
    const tile = new Meta.Rectangle();
    tile.x = desktop.x + this.gap;
    tile.y = desktop.y + this.gap;
    tile.width = desktop.width - (this.gap * 2);
    tile.height = (desktop.height / 2) - (this.gap * 1.5);
    return tile;
  }

  getLeftTile(win) {
    const desktop = this.getDesktop(win);
    const tile = new Meta.Rectangle();
    tile.x = desktop.x + this.gap;
    tile.y = desktop.y + this.gap;
    tile.width = (desktop.width / 2) - (this.gap * 1.5);
    tile.height = (desktop.height) - (this.gap * 2);
    return tile;
  }

  getRightTile(win) {
    const desktop = this.getDesktop(win);
    const tile = new Meta.Rectangle();
    tile.x = desktop.x + (desktop.width * 0.5) + (this.gap * 0.5);
    tile.y = desktop.y + this.gap;
    tile.width = (desktop.width / 2) - (this.gap * 1.5);
    tile.height = (desktop.height) - (this.gap * 2);
    return tile;
  }

  getDownLeftTile(win) {
    const desktop = this.getDesktop(win);
    const tile = new Meta.Rectangle();
    tile.x = desktop.x + this.gap;
    tile.y = desktop.y + (desktop.height / 2) + (this.gap * 0.5);
    tile.width = (desktop.width / 2) - (this.gap * 1.5);
    tile.height = (desktop.height / 2) - (this.gap * 1.5);
    return tile;
  }

  getUpLeftTile(win) {
    const desktop = this.getDesktop(win);
    const tile = new Meta.Rectangle();
    tile.x = desktop.x + this.gap;
    tile.y = desktop.y + this.gap;
    tile.width = (desktop.width / 2) - (this.gap * 1.5);
    tile.height = (desktop.height / 2) - (this.gap * 1.5);
    return tile;
  }

  // dirty start

  // tileUp() {
  //   log('tileup');
  //   const win = this.getWindow();
  //   const r = this.isRight(win) ? this.upRightRect(win) : this.rightRect(win);
  //   this.move(win, r.x, r.y, r.width, r.height);
  // }
  //
  // tileDown() {
  //   log('tiledown');
  //   const win = this.getWindow();
  //   const r = this.isRight(win) ? this.upRightRect(win) : this.rightRect(win);
  //   this.move(win, r.x, r.y, r.width, r.height);
  // }
  //
  // tileRight() {
  //   const win = this.getWindow();
  //   const r = this.rightRect(win);
  //   this.move(win, r.x, r.y, r.width, r.height);
  // }
  //
  //
  // upRightRect(win) {
  //   const desktop = this.getDesktop(win);
  //   const gap = 20;
  //   const r = new Meta.Rectangle();
  //   r.x = (desktop.width / 2) + desktop.x + (gap / 2);
  //   r.y = desktop.y + gap;
  //   r.width = (desktop.width / 2) - (gap * 1.5);
  //   r.height = (desktop.height / 2) - (gap * 1.5);
  //   return r;
  // }
  //
  // rightRect(win) {
  //   const desktop = this.getDesktop(win);
  //   const gap = 20;
  //   const r = new Meta.Rectangle();
  //   r.x = (desktop.width / 2) + desktop.x + (gap / 2);
  //   r.y = desktop.y + gap;
  //   r.width = (desktop.width / 2) - (gap * 1.5);
  //   r.height = (desktop.height) - (gap * 2);
  //   return r;
  // }

  // dirty end

  async move(win, tile) {
    await this.unmax(win);
    if (!win.allows_move() || !win.allows_resize() || win.is_skip_taskbar()) { return; }
    this.animate(win);
    win.move_resize_frame(false, tile.x, tile.y, tile.width, tile.height);
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
    Main.wm._prepareAnimationInfo(global.window_manager, compositor, win.get_frame_rect(), Meta.SizeChange.MAXIMIZE);
  }

  getWindow() { return global.display.get_focus_window(); }
  getDesktop(win) { return Main.layoutManager.getWorkAreaForMonitor(win.get_monitor()); }
  getMonitor(win) { return global.display.get_monitor_geometry(win.get_monitor()); }

  // log(rect) { console.log(`${rect.x} ${rect.y} ${rect.width} ${rect.height}`); }
}

// eslint-disable-next-line no-unused-vars
var init = () => new Extension();

