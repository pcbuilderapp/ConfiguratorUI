import 'dart:html';
import 'dart:collection';
import 'package:pcbuilder.api/transport/configuration.dart';
import 'package:pcbuilder.api/transport/componentitem.dart';

/// Generates the BuyOverviewDialog after evaluating current components.
class BuyOverviewDialog {
  Element _dialogElement;
  //Element _dialogMotherboard;

  BuyOverviewDialog() {
    _dialogElement = querySelector("#buyOverviewDialog");
    _dialogElement.querySelector(".closeBtn").onClick.listen((_) {
      close();
    });
  }

  void show(Configuration configuration) {
    Element content = _dialogElement.querySelector(".content");
    content.innerHtml = "";

    if (configuration.motherboard == null ||
        configuration.cpu == null ||
        configuration.gpu == null ||
        configuration.memory == null ||
        configuration.storage == null ||
        configuration.psu == null ||
        configuration.casing == null) {
      window.alert("Configuration incomplete.");
      return;
    }

    // _dialogMotherboard = new Element.a();
    /* _dialogMotherboard.onClick.listen((e) {
      querySelectorAll("#item").forEach((childElement) => classList.addAll(childElement.classes));
    });*/



    List<String> shopList = new List<String>();
    addIfNotExist(shopList, configuration.motherboard.shop);
    addIfNotExist(shopList, configuration.cpu.shop);
    addIfNotExist(shopList, configuration.gpu.shop);
    addIfNotExist(shopList, configuration.memory.shop);
    addIfNotExist(shopList, configuration.storage.shop);
    addIfNotExist(shopList, configuration.psu.shop);
    addIfNotExist(shopList, configuration.casing.shop);

    Iterator<String> iterator = shopList.iterator;

    for (String shop in shopList) {
      makeRow(content, shop);
      if(shop == configuration.motherboard.shop){
        makeLink(content, configuration.motherboard);
      }
      if(shop == configuration.cpu.shop){
        makeLink(content, configuration.cpu);
      }
      if(shop == configuration.gpu.shop){
        makeLink(content, configuration.gpu);
      }
      if(shop == configuration.memory.shop){
        makeLink(content, configuration.memory);
      }
      if(shop == configuration.storage.shop){
        makeLink(content, configuration.storage);
      }
      if(shop == configuration.psu.shop){
        makeLink(content, configuration.psu);
      }
      if(shop == configuration.motherboard.shop){
        makeLink(content, configuration.casing);
      }
    }

    _dialogElement.parent.style.display = "flex";
    _dialogElement.style.display = "block";
  }

  void addIfNotExist(List<String> shopList,String shop) {
      if(!shopList.contains(shop)){
      shopList.add(shop);
    }
  }

  /// Makes row for given string
  void makeRow(Element content, String shop) {
    content.append(new Element.p()..classes.add("item")
      ..append(new Element.div()
        ..text = shop
        ..classes.add("name"))
    );
  }

  /// Makes link row for given component using name,link and url
  void makeLink(Element content, ComponentItem component) {
    content.append(new Element.p()..classes.add("item")
      ..append(new Element.div()
        ..style.backgroundImage = "url(${component.image})"
        ..classes.add("image"))
      ..append(new Element.a()
        ..text = component.name
        ..attributes["href"] = component.url
        ..attributes["target"] = "_blank"
        ..classes.add("name"))
    );
  }

  void close() {
    _dialogElement.parent.style.display = "none";
    _dialogElement.style.display = "none";
  }
}