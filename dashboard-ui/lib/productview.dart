import 'package:uilib/view.dart';
import 'dart:html';
import 'dart:async';
import 'package:pcbuilder.api/config.dart';
import 'package:pcbuilder.api/transport/connector.dart';
import 'package:pcbuilder.api/transport/componentitem.dart';
import 'package:pcbuilder.api/transport/componentmatchingsearch.dart';
import 'package:pcbuilder.api/backend.dart';

class ProductView extends View {
  Element _viewElement = querySelector("#productview");
  static String get id => "productview";
  Element _productItem;
  Element _productList;
  Element _pager;
  InputElement _filterField;
  String _currentFilter;
  String _currentSort;
  int _currentPage;
  int _pageCount;
  int pageWidth = config["page-width"] ?? 5;

  void onShow() {
    querySelector("#productsNav").classes.add("active");
  }

  void onHide() {
    querySelector("#productsNav").classes.remove("active");
  }

  Future loadComponents(int page) async {
    // show load indicator
    _viewElement.querySelector(".content").style.display = "none";
    _viewElement.querySelector(".loading").style.display = "block";

    ComponentMatchingSearch componentSearchRequest =
    new ComponentMatchingSearch();
    componentSearchRequest.type = _currentType;
    componentSearchRequest.filter = _currentFilter;
    componentSearchRequest.sort = _currentSort;
    componentSearchRequest.configuration = _currentConfiguration;
    componentSearchRequest.maxItems = config["max-items"] ?? 30;
    componentSearchRequest.page = page;

    GetMatchingComponentsResponse componentSearchResponse =
    await backend.getMatchingComponents(componentSearchRequest);
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

    bool lastAddedPoints = false;

    for (int i = 0; i < componentSearchResponse.pages; i++) {
      if (showpage(i, componentSearchResponse.currentPage, pageWidth,
          componentSearchResponse.pages - 1)) {
        Element pagebtn = new Element.div();
        pagebtn.text = "${i + 1}";
        pagebtn.classes.add("pagebtn");

        if (i == componentSearchResponse.currentPage) {
          pagebtn.classes.add("current");
        } else {
          pagebtn.onClick.listen((_) {
            loadComponents(i);
          });
        }

        pages.append(pagebtn);
        lastAddedPoints = false;
      } else {
        if (!lastAddedPoints) {
          pages.append(points());
          lastAddedPoints = true;
        }
      }
    }

    // hide load indicator
    _viewElement.querySelector(".content").style.display = "block";
    _viewElement.querySelector(".loading").style.display = "none";
  }

  Element createComponentElement(ComponentItem item) {
    Element e = _productItem.clone(true);

    // product row
    e.querySelector(".fields .name").text = item.name;
    e.querySelector(".fields .brand").text = item.brand;
    e.querySelector(".fields .shop").text = item.shop;
    e.querySelector(".fields .price").text = formatCurrency(item.price);

    // show detail view for row
    e.querySelector(".fields").onClick.listen((_) {
      bool bIsActive = e.querySelector(".details").classes.contains("active");
      if (bIsActive) {
        e.querySelector(".details").classes.remove("active");
      } else {
        _productList
            .querySelector(".details.active")
            ?.classes
            ?.remove("active");
        e.querySelector(".details").classes.add("active");
      }
    });

    // product detail view
    e.querySelector(".details .productInfo .info .ean-nr").text =
        item.europeanArticleNumber;
    e.querySelector(".details .productInfo .info .mpn-nr").text =
        item.manufacturerPartNumber;
    e.querySelector(".details .productInfo .image").style.backgroundImage =
    "url(${item.image})";

    if (item.alternativeShops.length == 0) {
      e.querySelector(".alternativeShops").text = "No alternative shops found.";
    } else {
      Element shopsElement = e.querySelector(".alternativeShops");
      shopsElement.text = "Also sold by: ";
      for (AlternativeShopItem alternativeItem in item.alternativeShops) {
        shopsElement.append(makeUrl(alternativeItem.shop, alternativeItem.url));
      }
    }

    if (item.connectors.length != 0) {
      Element connectorsElement = e.querySelector(".connectors");

      for (Connector c in item.connectors) {
        Element connectorSpan = new Element.span()..classes.add("connector");

        Element connectorImg = new Element.span()
          ..classes.add("connector-icon-${c.type.toLowerCase()}");

        Element connectorSpanText = new Element.span()
          ..classes.add("connector-text");
        connectorSpanText.text = "${c.name} ";

        connectorSpan.append(connectorImg);
        connectorSpan.append(connectorSpanText);
        connectorsElement.append(connectorSpan);
        connectorsElement.appendText(" "); // for wraping
      }
    }

    // actions
    e.querySelector(".selectAction").onClick.listen((_) {
      _selectComponentCompleter.complete(item);
    });

    return e;
  }

  void filter(String filter) {
    if (filter == _currentFilter) return;
    _currentFilter = filter;
    loadComponents(0);
  }

  void setSort(String sortColumn) {
    if (sortColumn == _currentSort) return;
    _currentSort = sortColumn;
    _viewElement.querySelectorAll(".header-selected").classes.remove("header-selected");
    _viewElement.querySelector(".$sortColumn-header").classes.add("header-selected");
    loadComponents(0);
  }

  Element get element => _viewElement;
}
