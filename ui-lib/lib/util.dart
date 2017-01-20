library PCBuilder.Util;

import 'dart:html';
import "package:intl/intl.dart";

var eurosFormatter = new NumberFormat.currency(locale: "nl_NL", symbol: "€");

Element makeUrl(String name, String url) {
  Element e = new Element.a();
  e.attributes["href"] = url;
  e.text = name;
  return e;
}

String formatCurrency(double currency) {
  return eurosFormatter.format(currency);
}

int maxPage(int currentPage, int pageWidth, int totalPages) {
  return currentPage + pageWidth > totalPages ? totalPages : currentPage + pageWidth;
}

int minPage(int currentPage, int pageWidth) {
  return currentPage - pageWidth < 0 ? 0 : currentPage - pageWidth;
}

bool showpage(int page, int currentPage, int pageWidth, int totalPages) {
  return page == 0 || page == totalPages || (page <= currentPage + pageWidth && page >= currentPage - pageWidth);
}

Element points() {
  Element pagebtn = new Element.div();
  pagebtn.text = "...";
  pagebtn.classes.add("pagebtn");
  return pagebtn;
}