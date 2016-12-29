import 'dart:async';
import 'view.dart';
import 'dart:html';
import 'config.dart';
import 'componentitem.dart';
import 'componentmatchingsearch.dart';
import 'dart:convert';
import 'configuration.dart';
import 'backend.dart';
import 'pcbuilder.dart';
import 'util.dart';

class SelectComponentView extends View {
  SelectComponentView() {
    _viewElement = querySelector("#selectview");
    Element template = _viewElement.querySelector(".productItem");
    _productItem = template.clone(true);
    template.remove();
    _filterField = querySelector("#searchbar input") as InputElement;
    _productList = _viewElement.querySelector("#productList");
    (querySelector("#searchbar form") as FormElement).onSubmit.listen((Event e){
      filter(_filterField.value);
      e.preventDefault();
    });
    _viewElement.querySelector(".back-btn").onClick.listen((MouseEvent e){
      hide();
      pcbuilder.mainView.show();
    });
  }

  Future<ComponentItem> selectComponent(String componentType, Configuration configuration) async {
    _selectComponentCompleter = new Completer();
    _viewElement.querySelector("h2 .component-type").text = componentType;
    componentType = componentType.toUpperCase();
    if (componentType == "CASE") componentType = "CASING";
    show();

    // show load indicator

    ComponentMatchingSearch search =  new ComponentMatchingSearch();
    search.type = componentType;
    search.filter = _filterField.value;
    search.configuration = configuration;

    GetMatchingComponentsResponds responds = await backend.getMatchingComponents(search);
    _productList.innerHtml = "";

    // generate product list

    for (ComponentItem c in responds.components) {
      Element item = _productItem.clone(true);

      // product row

      item.querySelector(".fields .name").text = c.name;
      item.querySelector(".fields .shop").text = c.shop;
      item.querySelector(".fields .price").text = "€ ${c.price}";

      // product detail view

      item.querySelector(".details .productInfo .info .ean-nr").text = c.europeanArticleNumber;

      if (c.alternativeShops.length == 0) {
        item.querySelector(".alternativeShops").text = "No alternative shops found.";
      } else {
        Element shopsElement = item.querySelector(".alternativeShops");
        shopsElement.text = "Also sold by: ";
        for (AlternativeShopItem alternativeItem in c.alternativeShops) {
          shopsElement.append(makeUrl(alternativeItem.shop,alternativeItem.url));
        }
      }

      // actions

      item.querySelector(".selectAction").onClick.listen((_){
        _selectComponentCompleter.complete(c);
        hide();
      });

      _productList.append(item);
    }

    // set paging

    // hide load indicator

    return _selectComponentCompleter.future;
  }

  void filter(String filter) {

  }

  Element get element => _viewElement;

  Element _viewElement;
  Element _productItem;
  Element _productList;
  InputElement _filterField;
  Completer _selectComponentCompleter;
}
