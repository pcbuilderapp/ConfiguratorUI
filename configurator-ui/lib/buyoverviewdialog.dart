import 'dart:html';
import 'dart:collection';
import 'package:pcbuilder.api/transport/configuration.dart';

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

    while(iterator.moveNext()){
      makeShop(content, iterator.current);
      if(iterator.current == configuration.motherboard.shop){
        makeLink(content, configuration.motherboard.image, configuration.motherboard.name, configuration.motherboard.url);
      }
      if(iterator.current == configuration.cpu.shop){
        makeLink(content, configuration.cpu.image, configuration.cpu.name, configuration.cpu.url);
      }
      if(iterator.current == configuration.gpu.shop){
        makeLink(content, configuration.gpu.image, configuration.gpu.name, configuration.gpu.url);
      }
      if(iterator.current == configuration.memory.shop){
        makeLink(content, configuration.memory.image, configuration.memory.name, configuration.memory.url);
      }
      if(iterator.current == configuration.storage.shop){
        makeLink(content, configuration.storage.image, configuration.storage.name, configuration.storage.url);
      }
      if(iterator.current == configuration.psu.shop){
        makeLink(content, configuration.psu.image, configuration.psu.name, configuration.psu.url);
      }
      if(iterator.current == configuration.motherboard.shop){
        makeLink(content, configuration.casing.image, configuration.casing.name, configuration.casing.url);
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

  void makeShop(Element content, String shop) {
    content.append(new Element.p()..classes.add("item")
      ..append(new Element.div()
        ..text = shop
        ..classes.add("name"))
    );
  }

  void makeLink(Element content, String imageUrl, String name, String url) {
    content.append(new Element.p()..classes.add("item")
      ..append(new Element.div()
        ..style.backgroundImage = "url(${imageUrl})"
        ..classes.add("image"))
      ..append(new Element.a()
        ..text = name
        ..attributes["href"] = url
        ..attributes["target"] = "_blank"
        ..classes.add("name"))
    );
  }

  void close() {
    _dialogElement.parent.style.display = "none";
    _dialogElement.style.display = "none";
  }
}