import 'dart:async';
import 'dart:html';
import 'componenttype.dart';
import 'component.dart';
import 'componentmatchingsearch.dart';
import 'dart:convert';
import 'configuration.dart';
import 'config.dart';

class GetMatchingComponentsResponds {
  List<Component> components = [];
  int pages;
  int currentPage;
}

Backend backend = new Backend();

class Backend {
  Future<GetMatchingComponentsResponds> getMatchingComponents(
      ComponentMatchingSearch filter) async {
    String data = (new JsonEncoder()).convert(filter);

    HttpRequest request;

    try {
      request = await HttpRequest.request(
          BACKEND_SERVER + "component/getmatchingcomponents",
          method: "POST",
          sendData: data,
          requestHeaders: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          });
    } catch (e) {
      print(e);
      return new GetMatchingComponentsResponds();
    }

    GetMatchingComponentsResponds responds =
    new GetMatchingComponentsResponds();

    List<Map> json = new JsonDecoder().convert(request.responseText);
    for (Map componentData in json) {
      Component component = new Component();
      component.id = componentData["id"];
      component.name = componentData["name"];
      component.brand = componentData["brand"];
      component.europeanArticleNumber = componentData["europeanArticleNumber"];
      component.manufacturerPartNumber = componentData["manufacturerPartNumber"];
      component.type = filter.type;

      component.price = 0.0;
      component.shop = "PCBuilder";
      component.url = "#";

      responds.components.add(component);
    }

    responds.pages = 1;
    responds.currentPage = 1;

    return responds;
  }
}
