import 'dart:html';


class HelpDialog {
  Element _dialogElement;

  HelpDialog() {
    _dialogElement = querySelector("#helpDialog");
    _dialogElement.querySelector(".closeBtn").onClick.listen((_){
      close();
    });
  }

  void show() {
    _dialogElement.parent.style.display = "flex";
    _dialogElement.style.display = "block";
  }

  void close() {
    _dialogElement.parent.style.display = "none";
    _dialogElement.style.display = "none";
  }
}