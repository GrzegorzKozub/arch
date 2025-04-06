import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

export default class Panel extends Extension {
  enable() {
    this.hideA11y();
  }

  disable() {
    this.showA11y();
  }

  a11y() { return Main.panel.statusArea['a11y']; }
  hideA11y() { const a11y = this.a11y(); if (a11y) { a11y.container.hide(); } }
  showA11y() { const a11y = this.a11y(); if (a11y) { a11y.container.show(); } }
}

