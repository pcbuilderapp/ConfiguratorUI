import 'package:uilib/view.dart';
import 'dart:html';

class SearchesView extends View {
  Element _element = querySelector("#searchesview");
  static String get id => "searchesview";

  void onShow() {
    querySelector("#searchesNav").classes.add("active");
  }

  void onHide() {
    querySelector("#searchesNav").classes.remove("active");
  }

  Element get element => _element;
}
