library uilib.view;

import 'dart:html';

abstract class View {
  void hide() {
    element.style.display = "none";
    onHide();
  }

  void show() {
    element.style.display = "block";
    onShow();
  }

  void onShow();
  void onHide();
  Element get element;
}
