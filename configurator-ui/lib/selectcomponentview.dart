import 'dart:async';
import 'package:uilib/view.dart';
import 'dart:html';
import 'package:pcbuilder.api/config.dart';
import 'package:pcbuilder.api/transport/componentitem.dart';
import 'package:pcbuilder.api/transport/componentmatchingsearch.dart';
import 'dart:convert';
import 'package:pcbuilder.api/transport/configuration.dart';
import 'package:pcbuilder.api/backend.dart';
import 'pcbuilder.dart';
import 'package:uilib/util.dart';
import 'mainview.dart';

class SelectComponentView extends View {
  static String get id => "selectcomponent";

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
      pcbuilder.setView(MainView.id);
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
    pcbuilder.setView("selectcomponent");

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
    componentSearchRequest.maxItems = config["max-items"] ?? 30;
    componentSearchRequest.page = page;

    GetMatchingComponentsResponse componentSearchResponse = await backend.getMatchingComponents(componentSearchRequest);
    _productList.innerHtml = "";

    // generate product list

    for (ComponentItem c in componentSearchResponse.components) {
      _productList.append(createComponentElement(c));
    }

    // set paging

    _currentPage = componentSearchResponse.currentPage;
    _pageCount = componentSearchResponse.pages;
    Element pages = _pager.querySelector(".pages");
    pages.innerHtml = "";

    // TODO: max nr of page buttons?
    for (int i=0;i<componentSearchResponse.pages;i++) {
      Element pagebtn = new Element.div();
      pagebtn.text = "${i+1}";
      pagebtn.classes.add("pagebtn");
      if (i == componentSearchResponse.currentPage) {
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

    // show detail view for row
    e.querySelector(".fields").onClick.listen((_){
      bool bIsActive = e.querySelector(".details").classes.contains("active");
      if (bIsActive) {
        e.querySelector(".details").classes.remove("active");
      } else {
        _productList.querySelector(".details.active")?.classes?.remove("active");
        e.querySelector(".details").classes.add("active");
      }
    });

    // product detail view
    e.querySelector(".details .productInfo .info .ean-nr").text = item.europeanArticleNumber;
    e.querySelector(".details .productInfo .image").style.backgroundImage = "url(${item.image})";

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
    });

    return e;
  }

  void filter(String filter) {
    if (filter == _currentFilter) return;
    _currentFilter = filter;
    loadComponents(0);
  }

  void onShow() {

  }

  void onHide() {

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
