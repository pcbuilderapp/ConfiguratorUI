import 'package:uilib/view.dart';
import 'dart:html';

class CrawlersView extends View {
  Element _element = querySelector("#crawlersview");
  static String get id => "crawlersview";

  void onShow() {
    querySelector("#crawlersNav").classes.add("active");
  }

  void onHide() {
    querySelector("#crawlersNav").classes.remove("active");
  }

  Element get element => _element;
}
