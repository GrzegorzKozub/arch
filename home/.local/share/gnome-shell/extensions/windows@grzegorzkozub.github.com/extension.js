import GLib from 'gi://GLib';
import Meta from 'gi://Meta';
import Mtk from 'gi://Mtk';
import Shell from 'gi://Shell';
import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

export default class Windows extends Extension {
  host = null;
  windowCreatedHandler;
  windowEnteredMonitorHandler;
  grabOpBeginHandler;
  grabOpEndHandler;
  grabbing = false;
  pendingFix = null;
  config = [];
  configAuto = [];
  configInitial = [];
  initial = {};

  constructor(metadata) {
    super(metadata);
    const big = [
      {
        class: /^brave-browser$/,
        auto: true,
        host: 'drifter',
        largerThan: { width: 2400, height: 1800 },
      },
      {
        class: /^brave-browser$/,
        auto: true,
        host: ['player', 'worker'],
        largerThan: { width: 1920, height: 1080 },
      },
      { title: /^DBeaver.?/, auto: true },
      { class: /^draw.io$/ },
      {
        class: /^microsoft-edge$/,
        auto: true,
        host: 'drifter',
        largerThan: { width: 2400, height: 1800 },
      },
      {
        class: /^microsoft-edge$/,
        auto: true,
        host: ['player', 'worker'],
        largerThan: { width: 1920, height: 1080 },
      },
      { title: /.?GIMP$/ },
      { title: /^GNU Image Manipulation Program$/ },
      { class: /^org.inkscape.Inkscape$/ },
      {
        class: /^jetbrains-idea-ce$/,
        exceptTitle: /^Welcome to IntelliJ IDEA$/,
        auto: true,
      },
      { class: /^LM-Studio$/, auto: true },
      { class: /^com.obsproject.Studio$/ },
      { class: /^com.github.PintaProject.Pinta$/ },
      { class: /^Postman$/, auto: true },
      { title: /.?Visual Studio Code$/, auto: true },
      {
        class: /^dev.zed.Zed$/,
        exceptTitle: /^(About Zed|Zed — Settings)$/,
        auto: true,
      },
    ];
    const medium = [
      // { title: /^DevTools.?/ },
      { class: /^com.github.wwmm.easyeffects$/ },
      { class: /^com.github.johnfactotum.Foliate$/ },
      { title: /^Welcome to IntelliJ IDEA$/, auto: true },
      {
        class: /.?org.keepassxc.KeePassXC$/,
        exceptTitle: /^(Generate Password|Unlock Database)/,
        auto: true,
      },
      { class: /^io.github.ilya_zlobintsev.LACT$/, auto: true },
      { title: /.?LibreOffice.?/, auto: true },
      { class: /^io.missioncenter.MissionCenter$/, auto: true },
      { class: /^obsidian$/, auto: true },
      { class: /^ONLYOFFICE$/ },
      { class: /^org.gnome.Papers$/ },
      { title: /.?Steam$/ },
      { class: /^teams-for-linux$/, auto: true },
      {
        class: /^tidal-hifi$/,
        exceptTitle: /^Tidal Hi-Fi settings$/,
        auto: true,
      },
    ];
    const small = [
      // { title: /^Open/ }, // file pickers
      { class: /^io.bassi.Amberol$/ },
      { class: /^org.gnome.Extensions$/ },
      { class: /^Gufw.py$/ },
      { class: /^localsend$/, auto: true },
      { title: /^Settings$/ },
      { class: /^org.gnome.seahorse.Application$/ },
      { class: /^org.gnome.SystemMonitor$/ },
      { class: /^org.pulseaudio.pavucontrol$/ },
      { class: /^org.gnome.Weather$/ },
    ];
    const center = [{ class: /^com.mitchellh.ghostty$/, auto: true }];
    const initial = [
      // { class: /^com.mitchellh.ghostty$/, initial: true },
      { class: /^kitty$/, initial: true, full: true },
      { class: /^org.gnome.Nautilus$/, initial: true },
    ];
    const addConfig = (config, fix) => {
      this.config.push(...config.map((cfg) => ({ ...cfg, fix })));
    };
    addConfig(big, this.big.bind(this));
    addConfig(medium, this.medium.bind(this));
    addConfig(small, this.small.bind(this));
    addConfig(center, this.center.bind(this));
    addConfig(initial, this.restore.bind(this));
    this.configAuto = this.config.filter((cfg) => cfg.auto);
    this.configInitial = this.config.filter((cfg) => cfg.initial);
  }

  enable() {
    const getHost = () => {
      try {
        return GLib.file_get_contents('/etc/hostname')[1].toString().trim();
      } catch {
        return null;
      }
    };
    this.host = getHost();
    this.windowCreatedHandler = global.display.connect(
      'window-created',
      this.windowCreated.bind(this),
    );
    this.windowEnteredMonitorHandler = global.display.connect(
      'window-entered-monitor',
      this.windowEnteredMonitor.bind(this),
    );
    this.grabOpBeginHandler = global.display.connect('grab-op-begin', () => {
      this.grabbing = true;
    });
    this.grabOpEndHandler = global.display.connect('grab-op-end', () => {
      this.grabbing = false;
      if (this.pendingFix) {
        const win = this.pendingFix;
        this.pendingFix = null;
        this.fixMonitor(win);
      }
    });
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
    global.display.disconnect(this.windowEnteredMonitorHandler);
    global.display.disconnect(this.grabOpBeginHandler);
    global.display.disconnect(this.grabOpEndHandler);
    this.grabbing = false;
    this.pendingFix = null;
    for (const key of [
      'fix-all',
      'fix-active',
      'tile-full',
      'tile-left',
      'tile-right',
      'tile-down',
      'tile-up',
    ]) {
      Main.wm.removeKeybinding(key);
    }
  }

  addKeybinding(name, handler) {
    const settings = this.getSettings('org.gnome.shell.extensions.windows');
    Main.wm.addKeybinding(
      name,
      settings,
      Meta.KeyBindingFlags.IGNORE_AUTOREPEAT,
      Shell.ActionMode.NORMAL | Shell.ActionMode.OVERVIEW,
      handler.bind(this),
    );
  }

  windowCreated = (_, win) => this.fixAuto(win);
  windowEnteredMonitor = (_, __, win) => this.fixMonitor(win);

  fixAllHotkeyPressed = () => this.fixAll();
  fixActiveHotkeyPressed = () => this.fixActive();
  tileFullHotkeyPressed = () => this.tileFull();
  tileLeftHotkeyPressed = () => this.tileLeft();
  tileRightHotkeyPressed = () => this.tileRight();
  tileDownHotkeyPressed = () => this.tileDown();
  tileUpHotkeyPressed = () => this.tileUp();

  fixAuto(win) {
    // first app window doesn't auto-fix with shorter wait
    GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, () => {
      if (!win.get_compositor_private()) return GLib.SOURCE_REMOVE;
      this.fix(this.configAuto, win);
      this.save(this.configInitial, win);
      return GLib.SOURCE_REMOVE;
    });
  }

  fixMonitor(win) {
    if (this.grabbing) {
      this.pendingFix = win;
      return;
    }
    const cfg = this.findConfig(this.config, win);
    if (!cfg) {
      return;
    }
    if (cfg.full) {
      this.full(win);
    } else {
      cfg.fix(win);
    }
  }

  fixAll() {
    global
      .get_window_actors()
      .forEach((actor) => this.fix(this.config, actor.meta_window));
  }

  fixActive() {
    const win = this.getWindow();
    if (win) {
      this.fix(this.config, win);
    }
  }

  fix(config, win) {
    const cfg = this.findConfig(config, win);
    if (!cfg) {
      return;
    }
    cfg.fix(win);
  }

  save(config, win) {
    const cfg = this.findConfig(config, win);
    if (!cfg) {
      return;
    }
    this.initial[win.wm_class] = win.get_frame_rect();
  }

  findConfig = (config, win) => {
    const scale = global.display.get_monitor_scale(win.get_monitor());
    return config.find(
      (cfg) =>
        (this.matchTitle(cfg, win) || this.matchClass(cfg, win)) &&
        this.matchRole(cfg, win) &&
        this.matchSize(cfg, win, scale) &&
        this.matchHost(cfg),
    );
  };

  matchTitle = (cfg, win) => cfg.title && cfg.title.test(win.title);
  matchClass = (cfg, win) =>
    cfg.class &&
    cfg.class.test(win.wm_class) &&
    (!cfg.exceptTitle || !cfg.exceptTitle.test(win.title));
  matchRole = (cfg, win) =>
    !cfg.exceptRole || cfg.exceptRole !== win.get_role();

  matchSize = (cfg, win, scale) => {
    if (!cfg.largerThan) {
      return true;
    }
    const { width, height } = win.get_frame_rect();
    return (
      (!cfg.largerThan.width || cfg.largerThan.width < width * scale) &&
      (!cfg.largerThan.height || cfg.largerThan.height < height * scale)
    );
  };

  matchHost = (cfg) => {
    if (!cfg.host) {
      return true;
    }
    if (Array.isArray(cfg.host)) {
      return cfg.host.includes(this.host);
    }
    return cfg.host === this.host;
  };

  activate(win) {
    const now = global.get_current_time();
    const workspace = win.get_workspace();
    if (workspace) {
      workspace.activate_with_focus(win, now);
    } else {
      win.activate(now);
    }
  }

  big(win) {
    if (this.onUhd(win)) {
      this.adjust(win, 12, 14);
    } else {
      this.adjust(win, 14, 14.5);
    }
  }

  medium(win) {
    if (this.onUhd(win)) {
      this.adjust(win, 9, 12);
    } else {
      this.adjust(win, 12, 12.5);
    }
  }

  small(win) {
    if (this.onUhd(win)) {
      this.adjust(win, 6, 10);
    } else {
      this.adjust(win, 10, 10.5);
    }
  }

  onUhd(win) {
    const monitor = win.get_monitor();
    const { width, height } = global.display.get_monitor_geometry(monitor);
    const scale = global.display.get_monitor_scale(monitor);
    return width * scale === 3840 && height * scale === 2160;
  }

  adjust(win, width, height) {
    const tile = this.getAdjustment(win, width, height);
    if (tile.equal(win.get_frame_rect())) {
      return;
    }
    this.move(win, tile);
  }

  getAdjustment(win, width, height) {
    const step = 16;
    const desktop = this.getDesktop(win);
    return new Tile(
      (desktop.width / step) * ((step - width) / 2) + desktop.x,
      (desktop.height / step) * ((step - height) / 2) + desktop.y,
      (desktop.width / step) * width,
      (desktop.height / step) * height,
    );
  }

  center(win) {
    const tile = this.getCentered(win);
    if (tile) {
      this.move(win, tile, false);
    }
  }

  getCentered(win) {
    const rect = win.get_frame_rect();
    const desktop = this.getDesktop(win);
    const tile = new Tile(
      (desktop.width - rect.width) / 2 + desktop.x,
      (desktop.height - rect.height) / 2 + desktop.y,
      rect.width,
      rect.height,
    );
    return tile.equal(rect) ? false : tile;
  }

  restore(win) {
    const initial = this.initial[win.wm_class];
    if (!initial || initial.equal(win.get_frame_rect())) {
      return;
    }
    this.move(win, initial);
  }

  full(win) {
    const tiles = this.getTiles(win);
    if (tiles.full.equal(win.get_frame_rect())) {
      return;
    }
    this.move(win, tiles.full);
  }

  tileFull() {
    const win = this.getWindow();
    if (win) {
      this.full(win);
    }
  }

  tileLeft() {
    const [win, tiles, now] = this.getTilingSetup();
    if (
      tiles.left.equal(now) ||
      tiles.leftDown.equal(now) ||
      tiles.leftUp.equal(now)
    ) {
      return;
    }
    if (tiles.down.equal(now)) {
      this.move(win, tiles.leftDown);
      return;
    }
    if (tiles.up.equal(now)) {
      this.move(win, tiles.leftUp);
      return;
    }
    if (tiles.right.equal(now)) {
      this.move(win, tiles.full);
      return;
    }
    if (tiles.rightDown.equal(now)) {
      this.move(win, tiles.down);
      return;
    }
    if (tiles.rightUp.equal(now)) {
      this.move(win, tiles.up);
      return;
    }
    this.move(win, tiles.left);
  }

  tileRight() {
    const [win, tiles, now] = this.getTilingSetup();
    if (
      tiles.right.equal(now) ||
      tiles.rightDown.equal(now) ||
      tiles.rightUp.equal(now)
    ) {
      return;
    }
    if (tiles.down.equal(now)) {
      this.move(win, tiles.rightDown);
      return;
    }
    if (tiles.up.equal(now)) {
      this.move(win, tiles.rightUp);
      return;
    }
    if (tiles.left.equal(now)) {
      this.move(win, tiles.full);
      return;
    }
    if (tiles.leftDown.equal(now)) {
      this.move(win, tiles.down);
      return;
    }
    if (tiles.leftUp.equal(now)) {
      this.move(win, tiles.up);
      return;
    }
    this.move(win, tiles.right);
  }

  tileDown() {
    const [win, tiles, now] = this.getTilingSetup();
    if (
      tiles.down.equal(now) ||
      tiles.leftDown.equal(now) ||
      tiles.rightDown.equal(now)
    ) {
      return;
    }
    if (tiles.up.equal(now)) {
      this.move(win, tiles.full);
      return;
    }
    if (tiles.left.equal(now)) {
      this.move(win, tiles.leftDown);
      return;
    }
    if (tiles.right.equal(now)) {
      this.move(win, tiles.rightDown);
      return;
    }
    if (tiles.leftUp.equal(now)) {
      this.move(win, tiles.left);
      return;
    }
    if (tiles.rightUp.equal(now)) {
      this.move(win, tiles.right);
      return;
    }
    this.move(win, tiles.down);
  }

  tileUp() {
    const [win, tiles, now] = this.getTilingSetup();
    if (
      tiles.up.equal(now) ||
      tiles.leftUp.equal(now) ||
      tiles.rightUp.equal(now)
    ) {
      return;
    }
    if (tiles.down.equal(now)) {
      this.move(win, tiles.full);
      return;
    }
    if (tiles.left.equal(now)) {
      this.move(win, tiles.leftUp);
      return;
    }
    if (tiles.right.equal(now)) {
      this.move(win, tiles.rightUp);
      return;
    }
    if (tiles.leftDown.equal(now)) {
      this.move(win, tiles.left);
      return;
    }
    if (tiles.rightDown.equal(now)) {
      this.move(win, tiles.right);
      return;
    }
    this.move(win, tiles.up);
  }

  getTilingSetup() {
    const win = this.getWindow();
    if (!win) return;
    return [win, this.getTiles(win), win.get_frame_rect()];
  }

  getTiles(win) {
    const gap =
      global.display.get_monitor_scale(win.get_monitor()) >= 3 ? 12 : 16;
    const step = 2;
    const master = 1;
    const desktop = this.getDesktop(win);
    const xLeft = desktop.x + gap;
    const xRight = desktop.x + (desktop.width / step) * master + gap * 0.5;
    const yDown = desktop.y + desktop.height / 2 + gap * 0.5;
    const yUp = desktop.y + gap;
    const widthFull = desktop.width - gap * 2;
    const widthLeft = (desktop.width / step) * master - gap * 1.5;
    const widthRight = (desktop.width / step) * (step - master) - gap * 1.5;
    const heightFull = desktop.height - gap * 2;
    const heightHalf = desktop.height / 2 - gap * 1.5;
    return {
      full: new Tile(xLeft, yUp, widthFull, heightFull),
      left: new Tile(xLeft, yUp, widthLeft, heightFull),
      right: new Tile(xRight, yUp, widthRight, heightFull),
      down: new Tile(xLeft, yDown, widthFull, heightHalf),
      up: new Tile(xLeft, yUp, widthFull, heightHalf),
      leftDown: new Tile(xLeft, yDown, widthLeft, heightHalf),
      leftUp: new Tile(xLeft, yUp, widthLeft, heightHalf),
      rightDown: new Tile(xRight, yDown, widthRight, heightHalf),
      rightUp: new Tile(xRight, yUp, widthRight, heightHalf),
    };
  }

  async move(win, tile, resize = true) {
    await this.unmax(win);
    if (!win.allows_move() || !win.allows_resize() || win.is_skip_taskbar()) {
      return;
    }
    this.animate(win);
    if (resize) {
      win.move_resize_frame(false, tile.x, tile.y, tile.width, tile.height);
    } else {
      win.move_frame(false, tile.x, tile.y);
    }
    this.ensureAnimationComplete(win);
  }

  ensureAnimationComplete(win) {
    GLib.timeout_add(GLib.PRIORITY_DEFAULT, 250, () => {
      const actor = win.get_compositor_private();
      if (actor) {
        Main.wm._sizeChangeWindowDone(global.window_manager, actor);
      }
      return GLib.SOURCE_REMOVE;
    });
  }

  unmax = (win) =>
    new Promise((resolve) => {
      if (win.is_maximized()) {
        win.unmaximize();
        GLib.timeout_add(GLib.PRIORITY_DEFAULT, 250, () => {
          resolve();
          return GLib.SOURCE_REMOVE;
        });
      } else {
        resolve();
      }
    });

  animate(win) {
    const compositor = win.get_compositor_private();
    compositor.remove_all_transitions();
    Main.wm._prepareAnimationInfo(
      global.window_manager,
      compositor,
      win.get_frame_rect(),
      Meta.SizeChange.UNMAXIMIZE,
    );
  }

  getWindow = () => global.display.get_focus_window();
  getDesktop = (win) =>
    Main.layoutManager.getWorkAreaForMonitor(win.get_monitor());
}

class Tile {
  constructor(...params) {
    this.rect = new Mtk.Rectangle();
    this.rect.x = params[0];
    this.rect.y = params[1];
    this.rect.width = params[2];
    this.rect.height = params[3];
  }
  get x() {
    return this.rect.x;
  }
  get y() {
    return this.rect.y;
  }
  get width() {
    return this.rect.width;
  }
  get height() {
    return this.rect.height;
  }
  equal(rect) {
    if (this.rect.equal(rect)) {
      return true;
    }
    const close = (val1, val2) => Math.abs(val1 - val2) <= 1;
    return (
      close(this.rect.x, rect.x) &&
      close(this.rect.y, rect.y) &&
      close(this.rect.width, rect.width) &&
      close(this.rect.height, rect.height)
    );
  }
}
