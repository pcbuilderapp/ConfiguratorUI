import 'dart:async';
import 'view.dart';
import 'dart:html';
import 'config.dart';
import 'package:ConfiguratorUI/transport/componentitem.dart';
import 'package:ConfiguratorUI/transport/componentmatchingsearch.dart';
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
    _filterField.onSearch.listen((_){
      filter(_filterField.value);
    });
    _productList = _viewElement.querySelector("#productList");
    (querySelector("#searchbar form") as FormElement).onSubmit.listen((Event e){
      filter(_filterField.value);
      e.preventDefault();
    });
    _viewElement.querySelector(".back-btn").onClick.listen((MouseEvent e){
      hide();
      pcbuilder.mainView.show();
    });
    _pager = querySelector("#pager");
    _pager.querySelector(".previous").onClick.listen((_){
      if (_currentPage <= 1) return;
      loadComponents(_currentPage-1);
    });
    _pager.querySelector(".next").onClick.listen((_){
      if (_currentPage >= _pageCount) return;
      loadComponents(_currentPage+1);
    });
  }

  Future<ComponentItem> selectComponent(String componentType, Configuration configuration) async {
    _selectComponentCompleter = new Completer();
    _viewElement.querySelector("h2 .component-type").text = componentType;
    componentType = componentType.toUpperCase();
    if (componentType == "CASE") componentType = "CASING";
    show();

    _currentType = componentType;
    _currentConfiguration = configuration;
    _currentFilter = "";
    _filterField.value = "";

    loadComponents(0);

    return _selectComponentCompleter.future;
  }

  Future loadComponents(int page) async {
    // show load indicator
    _viewElement.querySelector(".content").style.display = "none";
    _viewElement.querySelector(".loading").style.display = "block";

    ComponentMatchingSearch componentSearchRequest =  new ComponentMatchingSearch();
    componentSearchRequest.type = _currentType;
    componentSearchRequest.filter = _currentFilter;
    componentSearchRequest.configuration = _currentConfiguration;
    componentSearchRequest.maxItems = MAX_ITEMS;
    componentSearchRequest.page = page;

    GetMatchingComponentsResponds componentSearchResponds = await backend.getMatchingComponents(componentSearchRequest);
    _productList.innerHtml = "";

    // generate product list

    for (ComponentItem c in componentSearchResponds.components) {
      _productList.append(createComponentElement(c));
    }

    // set paging

    _currentPage = componentSearchResponds.currentPage;
    _pageCount = componentSearchResponds.pages;
    Element pages = _pager.querySelector(".pages");
    pages.innerHtml = "";

    // TODO: max nr of page buttons?
    for (int i=0;i<componentSearchResponds.pages;i++) {
      Element pagebtn = new Element.div();
      pagebtn.text = "${i+1}";
      pagebtn.classes.add("pagebtn");
      if (i == componentSearchResponds.currentPage) {
        pagebtn.classes.add("current");
      } else {
        pagebtn.onClick.listen((_) {
          loadComponents(i);
        });
      }
      pages.append(pagebtn);
    }

    // hide load indicator
    _viewElement.querySelector(".content").style.display = "block";
    _viewElement.querySelector(".loading").style.display = "none";
  }

  Element createComponentElement(ComponentItem item) {
    Element e = _productItem.clone(true);

    // product row

    e.querySelector(".fields .name").text = item.name;
    e.querySelector(".fields .shop").text = item.shop;
    e.querySelector(".fields .price").text = "€ ${item.price}";

    // product detail view

    e.querySelector(".details .productInfo .info .ean-nr").text = item.europeanArticleNumber;

    if (item.alternativeShops.length == 0) {
      e.querySelector(".alternativeShops").text = "No alternative shops found.";
    } else {
      Element shopsElement = e.querySelector(".alternativeShops");
      shopsElement.text = "Also sold by: ";
      for (AlternativeShopItem alternativeItem in item.alternativeShops) {
        shopsElement.append(makeUrl(alternativeItem.shop,alternativeItem.url));
      }
    }

    // actions

    e.querySelector(".selectAction").onClick.listen((_){
      _selectComponentCompleter.complete(item);
      hide();
    });

    return e;
  }

  void filter(String filter) {
    if (filter == _currentFilter) return;
    _currentFilter = filter;
    loadComponents(0);
  }

  Element get element => _viewElement;

  Element _viewElement;
  Element _productItem;
  Element _productList;
  Element _pager;
  InputElement _filterField;
  Completer _selectComponentCompleter;
  String _currentType;
  String _currentFilter;
  Configuration _currentConfiguration;
  int _currentPage;
  int _pageCount;
}
