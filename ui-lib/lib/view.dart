library uilib.view;

import 'dart:html';

/// Base view class.

abstract class View {

  /// Hide the view.

  void hide() {
    element.style.display = "none";
    onHide();
  }

  /// Show the view.

  void show() {
    element.style.display = "block";
    onShow();
  }

  /// onShow event
  ///
  /// Event triggered when this view becomes the active view.

  void onShow();

  /// onHide event
  ///
  /// Event triggered when this view is no longer active.

  void onHide();

  /// Get view element
  ///
  /// Get the DOM element for this view.

  Element get element;
}
