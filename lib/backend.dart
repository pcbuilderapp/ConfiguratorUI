import 'dart:async';
import 'dart:html';
import 'componenttype.dart';
import 'component.dart';
import 'componentmatchingsearch.dart';
import 'dart:convert';
import 'configuration.dart';

class GetMatchingComponentsResponds {
  List<Component> components;
  int pages;
  int currentPage;
}

Backend backend = new Backend();

class Backend {
  Future<GetMatchingComponentsResponds> getMatchingComponents(ComponentMatchingSearch filter) async {
    /*
    String data = (new JsonEncoder()).convert(search);
    HttpRequest.postFormData(BACKEND_SERVER + "component/getmatchingcomponents",
        {"request": data}).then((HttpRequest request) {
      //request.responseText
    });
*/
    GetMatchingComponentsResponds responds = new GetMatchingComponentsResponds();
    responds.components = [
      new Component("ASUS GTX1080","ASUS","1234","5678",ComponentType.GPU),
      new Component("ASUS GTX1080","ASUS","1234","5678",ComponentType.GPU),
      new Component("ASUS GTX1080","ASUS","1234","5678",ComponentType.GPU)
    ];

    responds.pages = 1;
    responds.currentPage = 1;

    return responds;
  }
}