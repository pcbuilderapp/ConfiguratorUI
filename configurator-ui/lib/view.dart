
import 'dart:html';

abstract class View {
  void hide() {
    element.style.display = "none";
  }
  void show() {
    element.style.display = "block";
  }

  Element get element;
}