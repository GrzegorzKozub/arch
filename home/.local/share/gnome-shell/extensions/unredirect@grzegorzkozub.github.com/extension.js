// https://gitlab.gnome.org/GNOME/mutter/-/issues/1410
// https://gitlab.gnome.org/GNOME/mutter/-/issues/3419

import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';

export default class Unredirect extends Extension {
  origEnable = null;

  enable() {
    if (this.origEnable === null) {
      this.origEnable = global.compositor.enable_unredirect;
      global.compositor.enable_unredirect = function () {};
      global.compositor.disable_unredirect();
    }
  }

  disable() {
    if (this.origEnable !== null) {
      global.compositor.enable_unredirect = this.origEnable;
      global.compositor.enable_unredirect();
      this.origEnable = null;
    }
  }
}
