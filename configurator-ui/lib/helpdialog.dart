import 'dart:html';

/// The help dialog.

class HelpDialog {
  Element _dialogElement;

  HelpDialog() {
    _dialogElement = querySelector("#helpDialog");
    _dialogElement.querySelector(".closeBtn").onClick.listen((_){
      close();
    });
  }

  /// Show the help dialog.

  void show() {
    _dialogElement.parent.style.display = "flex";
    _dialogElement.style.display = "block";
  }

  /// Hide the help dialog.

  void close() {
    _dialogElement.parent.style.display = "none";
    _dialogElement.style.display = "none";
  }
}