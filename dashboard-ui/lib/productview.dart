import 'package:uilib/view.dart';
import 'dart:html';

class ProductView extends View {
  Element _element = querySelector("#productview");
  static String get id => "productview";

  void onShow() {
    querySelector("#productsNav").classes.add("active");
  }
  void onHide() {
    querySelector("#productsNav").classes.remove("active");
  }

  Element get element => _element;
}