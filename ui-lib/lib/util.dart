library PCBuilder.Util;

import 'dart:html';

Element makeUrl(String name, String url) {
  Element e = new Element.a();
  e.attributes["href"] = url;
  e.text = name;
  return e;
}