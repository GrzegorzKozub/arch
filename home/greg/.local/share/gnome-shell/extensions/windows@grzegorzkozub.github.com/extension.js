/* eslint-disable no-undef */

import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import GLib from 'gi://GLib';
import Meta from 'gi://Meta';
import Shell from 'gi://Shell';

export default class Windows extends Extension {
  windowCreatedHandler;
  config = [];
  initial = {};

  constructor(metadata) {
    super(metadata);
    const big = [
      { title: /.?Brave$/, auto: true, noRole: 'pop-up' },
      { title: /^DBeaver.?/, auto: true },
      { class: /^draw.io$/, auto: true },
      { title: /.?Inkscape$/ },
      { title: /.?MySQL Workbench$/ },
      { title: /^OBS.?/ },
      { class: /^Postman$/, auto: true, noRole: 'GtkFileChooserDialog' },
      { title: /.?Shotcut$/ },
      { title: /.?Visual Studio Code$/ },
      { class: /^dev.zed.Zed$/, auto: true },
    ];
    const medium = [
      { title: /^calibre.?/ },
      { title: /^DevTools.?/ },
      { class: /.?evince$/, auto: true },
      { title: /^Foliate.?/ },
      { title: /.?GIMP$/ },
      { title: /^GNU Image Manipulation Program$/ },
      { title: /.?KeePassXC$/ },
      { class: /^io.missioncenter.MissionCenter$/ },
      { title: /.?LibreOffice.?/ },
      { class: /^obsidian$/ },
      { title: /.?Slack$/, auto: true },
      { title: /.?Steam$/ },
      { class: /^teams-for-linux$/, auto: true },
    ];
    const small = [
      { class: /.?drawing.?/ },
      // { title: /^Open/ }, // file pickers
      { class: /^org.gnome.Extensions$/ },
      { class: /^org.gnome.SystemMonitor$/ },
      { title: /^Settings$/ },
    ];
    const initial = [
      { class: /^Alacritty$/, initial: true },
      { class: /^foot$/, initial: true },
      { class: /^kitty$/, initial: true },
      { class: /^org.gnome.Nautilus$/, initial: true },
    ];
    const addConfig = (config, fix) => {
      this.config.push(...config.map(cfg => ({ ...cfg, fix })));
    };
    addConfig(big, this.big.bind(this));
    addConfig(medium, this.medium.bind(this));
    addConfig(small, this.small.bind(this));
    addConfig(initial, this.restore.bind(this));
  }

  enable() {
    this.windowCreatedHandler = global.display.connect(
      'window-created',
      this.windowCreated.bind(this));
    this.addKeybinding('fix-all', this.fixAllHotkeyPressed);
    this.addKeybinding('fix-active', this.fixActiveHotkeyPressed);
    this.addKeybinding('tile-full', this.tileFullHotkeyPressed);
    this.addKeybinding('tile-left', this.tileLeftHotkeyPressed);
    this.addKeybinding('tile-right', this.tileRightHotkeyPressed);
    this.addKeybinding('tile-down', this.tileDownHotkeyPressed);
    this.addKeybinding('tile-up', this.tileUpHotkeyPressed);
  }

  disable() {
    global.display.disconnect(this.windowCreatedHandler);
    for (const key of ['fix-all', 'fix-active', 'tile-full', 'tile-left', 'tile-right', 'tile-down', 'tile-up']) {
      Main.wm.removeKeybinding(key);
    }
  }

  addKeybinding(name, handler) {
    Main.wm.addKeybinding(
      name,
      this.getSettings('org.gnome.shell.extensions.windows'),
      Meta.KeyBindingFlags.IGNORE_AUTOREPEAT,
      Shell.ActionMode.NORMAL | Shell.ActionMode.OVERVIEW,
      handler.bind(this));
  }

  windowCreated(_, win) { this.fixAuto(win); }
  fixAllHotkeyPressed() { this.fixAll(); }
  fixActiveHotkeyPressed() { this.fixActive(); }
  tileFullHotkeyPressed() { this.tileFull(); }
  tileLeftHotkeyPressed() { this.tileLeft(); }
  tileRightHotkeyPressed() { this.tileRight(); }
  tileDownHotkeyPressed() { this.tileDown(); }
  tileUpHotkeyPressed() { this.tileUp(); }

  fixAuto(win) {
    GLib.timeout_add(GLib.PRIORITY_DEFAULT, 500, () => {
      this.fix(this.config.filter(cfg => cfg.auto), win);
      this.save(this.config.filter(cfg => cfg.initial), win);
      // this.activate(win);
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
    const cfg = this.findConfig(config, win); if (!cfg) { return; }
    cfg.fix(win);
  }

  save(config, win) {
    const cfg = this.findConfig(config, win); if (!cfg) { return; }
    this.initial[win.wm_class] = win.get_frame_rect();
  }

  findConfig(config, win) {
    return config.find(cfg =>
      (cfg.title && cfg.title.test(win.title) || cfg.class && cfg.class.test(win.wm_class)) &&
      (!cfg.noRole || cfg.noRole !== win.get_role()));
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

  center(win, width, height) {
    const center = this.getCenterTile(win, width, height);
    if (center.equal(win.get_frame_rect())) { return; }
    this.move(win, center);
  }

  getCenterTile(win, width, height) {
    const step = 16; const desktop = this.getDesktop(win);
    return new Tile(
      ((desktop.width / step) * ((step - width) / 2)) + desktop.x,
      ((desktop.height / step) * ((step - height) / 2)) + desktop.y,
      (desktop.width / step) * width,
      (desktop.height / step) * height);
  }

  restore(win) {
    const initial = this.initial[win.wm_class];
    if (!initial || initial.equal(win.get_frame_rect())) { return; }
    this.move(win, initial);
  }

  tileFull() {
    const [win, tiles, now] = this.getTilingSetup();
    if (tiles.full.equal(now)) { return; }
    this.move(win, tiles.full);
  }

  tileLeft() {
    const [win, tiles, now] = this.getTilingSetup();
    if (tiles.left.equal(now) || tiles.leftDown.equal(now) || tiles.leftUp.equal(now)) { return; }
    if (tiles.down.equal(now)) { this.move(win, tiles.leftDown); return; }
    if (tiles.up.equal(now)) { this.move(win, tiles.leftUp); return; }
    if (tiles.right.equal(now)) { this.move(win, tiles.full); return; }
    if (tiles.rightDown.equal(now)) { this.move(win, tiles.down); return; }
    if (tiles.rightUp.equal(now)) { this.move(win, tiles.up); return; }
    this.move(win, tiles.left);
  }

  tileRight() {
    const [win, tiles, now] = this.getTilingSetup();
    if (tiles.right.equal(now) || tiles.rightDown.equal(now) || tiles.rightUp.equal(now)) { return; }
    if (tiles.down.equal(now)) { this.move(win, tiles.rightDown); return; }
    if (tiles.up.equal(now)) { this.move(win, tiles.rightUp); return; }
    if (tiles.left.equal(now)) { this.move(win, tiles.full); return; }
    if (tiles.leftDown.equal(now)) { this.move(win, tiles.down); return; }
    if (tiles.leftUp.equal(now)) { this.move(win, tiles.up); return; }
    this.move(win, tiles.right);
  }

  tileDown() {
    const [win, tiles, now] = this.getTilingSetup();
    if (tiles.down.equal(now) || tiles.leftDown.equal(now) || tiles.rightDown.equal(now)) { return; }
    if (tiles.up.equal(now)) { this.move(win, tiles.full); return; }
    if (tiles.left.equal(now)) { this.move(win, tiles.leftDown); return; }
    if (tiles.right.equal(now)) { this.move(win, tiles.rightDown); return; }
    if (tiles.leftUp.equal(now)) { this.move(win, tiles.left); return; }
    if (tiles.rightUp.equal(now)) { this.move(win, tiles.right); return; }
    this.move(win, tiles.down);
  }

  tileUp() {
    const [win, tiles, now] = this.getTilingSetup();
    if (tiles.up.equal(now) || tiles.leftUp.equal(now) || tiles.rightUp.equal(now)) { return; }
    if (tiles.down.equal(now)) { this.move(win, tiles.full); return; }
    if (tiles.left.equal(now)) { this.move(win, tiles.leftUp); return; }
    if (tiles.right.equal(now)) { this.move(win, tiles.rightUp); return; }
    if (tiles.leftDown.equal(now)) { this.move(win, tiles.left); return; }
    if (tiles.rightDown.equal(now)) { this.move(win, tiles.right); return; }
    this.move(win, tiles.up);
  }

  getTilingSetup() { const win = this.getWindow(); return [win, this.getTiles(win), win.get_frame_rect()]; }

  getTiles(win) {
    const gap = 25; const step = 2; const master = 1;
    const desktop = this.getDesktop(win);
    const xLeft = desktop.x + gap;
    const xRight = desktop.x + (desktop.width / step * master) + (gap * 0.5);
    const yDown = desktop.y + (desktop.height / 2) + (gap * 0.5);
    const yUp = desktop.y + gap;
    const widthFull = desktop.width - (gap * 2);
    const widthLeft = (desktop.width / step * master) - (gap * 1.5);
    const widthRight = (desktop.width / step * (step - master)) - (gap * 1.5);
    const heightFull = (desktop.height) - (gap * 2);
    const heightHalf = (desktop.height / 2) - (gap * 1.5);
    return {
      full: new Tile(xLeft, yUp, widthFull, heightFull),
      left: new Tile(xLeft, yUp, widthLeft, heightFull),
      right: new Tile(xRight, yUp, widthRight, heightFull),
      down: new Tile(xLeft, yDown, widthFull, heightHalf),
      up: new Tile(xLeft, yUp, widthFull, heightHalf),
      leftDown: new Tile(xLeft, yDown, widthLeft, heightHalf),
      leftUp: new Tile(xLeft, yUp, widthLeft, heightHalf),
      rightDown: new Tile(xRight, yDown, widthRight, heightHalf),
      rightUp: new Tile(xRight, yUp, widthRight, heightHalf)
    };
  }

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
    Main.wm._prepareAnimationInfo(global.window_manager, compositor, win.get_frame_rect(), Meta.SizeChange.UNMAXIMIZE);
  }

  getWindow() { return global.display.get_focus_window(); }
  getDesktop(win) { return Main.layoutManager.getWorkAreaForMonitor(win.get_monitor()); }
  getMonitor(win) { return global.display.get_monitor_geometry(win.get_monitor()); }
}

class Tile {
  constructor(...params) {
    this.rect = new Meta.Rectangle();
    this.rect.x = params[0];
    this.rect.y = params[1];
    this.rect.width = params[2];
    this.rect.height = params[3];
  }
  get x() { return this.rect.x; }
  get y() { return this.rect.y; }
  get width() { return this.rect.width; }
  get height() { return this.rect.height; }
  equal(rect) {
    if (this.rect.equal(rect)) { return true; }
    const close = (val1, val2) => Math.abs(val1 - val2) <= 1;
    return close(this.rect.x, rect.x) && close(this.rect.y, rect.y) &&
      close(this.rect.width, rect.width) && close(this.rect.height, rect.height);
  }
}

