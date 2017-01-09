import 'dart:async';
import 'dart:html';
import 'componenttype.dart';
import 'package:ConfiguratorUI/transport/componentitem.dart';
import 'package:ConfiguratorUI/transport/componentmatchingsearch.dart';
import 'dart:convert';
import 'configuration.dart';
import 'config.dart';

class GetMatchingComponentsResponds {
  List<ComponentItem> components = [];
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
          BACKEND_SERVER + "componentitem/getmatchingcomponents",
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

    Map json = new JsonDecoder().convert(request.responseText);
    for (Map componentData in json["components"]) {
      ComponentItem component = new ComponentItem();
      component.id = componentData["id"];
      component.name = componentData["name"];
      component.brand = componentData["brand"];
      component.europeanArticleNumber = componentData["europeanArticleNumber"];
      component.manufacturerPartNumber = componentData["manufacturerPartNumber"];
      component.type = filter.type;

      component.price = componentData["price"];
      component.shop = componentData["shop"];
      component.url = componentData["url"];

      for (Map alternativeShop in componentData["alternativeShops"]) {
        AlternativeShopItem shopItem = new AlternativeShopItem();
        shopItem.shop = alternativeShop["shop"];
        shopItem.url = alternativeShop["url"];
        shopItem.price = alternativeShop["price"];
        component.alternativeShops.add(shopItem);
      }

      responds.components.add(component);
    }

    responds.pages = json["pageCount"];
    responds.currentPage = json["page"];

    return responds;
  }
}
