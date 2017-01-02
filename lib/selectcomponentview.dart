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

    loadComponents(1);

    return _selectComponentCompleter.future;
  }

  Future loadComponents(int page) async {
    // show load indicator
    _viewElement.querySelector(".content").style.display = "none";
    _viewElement.querySelector(".loading").style.display = "block";

    ComponentMatchingSearch search =  new ComponentMatchingSearch();
    search.type = _currentType;
    search.filter = _currentFilter;
    search.configuration = _currentConfiguration;
    search.maxItems = MAX_ITEMS;
    search.page = page;

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

    _currentPage = responds.currentPage;
    _pageCount = responds.pages;
    Element pages = _pager.querySelector(".pages");
    pages.innerHtml = "";

    // TODO: max nr of page buttons?
    for (int i=1;i<=responds.pages;i++) {
      Element pagebtn = new Element.div();
      pagebtn.text = "$i";
      pagebtn.classes.add("pagebtn");
      if (i == responds.currentPage) {
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

  void filter(String filter) {
    if (filter == _currentFilter) return;
    _currentFilter = filter;
    loadComponents(1);
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
