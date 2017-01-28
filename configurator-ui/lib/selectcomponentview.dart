import 'dart:async';
import 'package:uilib/view.dart';
import 'dart:html';
import 'package:pcbuilder.api/config.dart';
import 'package:pcbuilder.api/domain/connector.dart';
import 'package:pcbuilder.api/transport/componentitem.dart';
import 'package:pcbuilder.api/transport/componentmatchingsearch.dart';
import 'package:pcbuilder.api/transport/configuration.dart';
import 'package:pcbuilder.api/transport/matchingcomponentsresponse.dart';
import 'package:pcbuilder.api/backend.dart';
import 'package:pcbuilder.api/transport/searchqueryaddrequest.dart';
import 'package:pcbuilder.api/domain/searchquerytype.dart';
import 'package:pcbuilder.api/transport/componentref.dart';
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
    _filterField.onSearch.listen((_) {
      filter(_filterField.value);
    });

    _productList = _viewElement.querySelector("#productList");
    (querySelector("#searchbar form") as FormElement)
        .onSubmit
        .listen((Event e) {
      filter(_filterField.value);
      e.preventDefault();
    });

    _viewElement.querySelector(".back-btn").onClick.listen((MouseEvent e) {
      pcbuilder.setView(MainView.id);
    });

    _viewElement.querySelector(".name-header").onClick.listen((MouseEvent e) {
      setSort("name");
    });
    _viewElement.querySelector(".shop-header").onClick.listen((MouseEvent e) {
      setSort("shop");
    });
    _viewElement.querySelector(".brand-header").onClick.listen((MouseEvent e) {
      setSort("brand");
    });
    _viewElement.querySelector(".price-header").onClick.listen((MouseEvent e) {
      setSort("price");
    });

    _pager = querySelector("#pager");
    _pager.querySelector(".previous").onClick.listen((_) {
      if (_currentPage <= 1) return;
      loadComponents(_currentPage - 1);
    });

    _pager.querySelector(".next").onClick.listen((_) {
      if (_currentPage >= _pageCount) return;
      loadComponents(_currentPage + 1);
    });
  }

  Future<ComponentItem> selectComponent(
      String componentType, Configuration configuration) async {
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
    _currentPage = componentSearchResponse.page;
    _pageCount = componentSearchResponse.pageCount;
    Element pages = _pager.querySelector(".pages");
    pages.innerHtml = "";

    bool lastAddedPoints = false;

    for (int i = 0; i < componentSearchResponse.pageCount; i++) {
      if (showpage(i, componentSearchResponse.page, pageWidth,
          componentSearchResponse.pageCount - 1)) {
        Element pagebtn = new Element.div();
        pagebtn.text = "${i + 1}";
        pagebtn.classes.add("pagebtn");

        if (i == componentSearchResponse.page) {
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
    Element priceField = e.querySelector(".fields .price")
      ..text = formatCurrency(item.price);

    if (item.discounted) {
      priceField.classes.add("discount");
      priceField.attributes['title'] = "This product is on sale.";
    }

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
      backend.postSearchQuery(new SearchQueryAddRequest()
        ..component = (new ComponentRef()..id=item.id)
        ..filter = _currentFilter
        ..type = SearchQueryType.SELECTION);
      _selectComponentCompleter.complete(item);
    });

    e.querySelector(".showAction").onClick.listen((_) {
      window.open(item.url,"_blank");
    });

    return e;
  }

  /// Set filter
  ///
  /// Set the current filter and fetch a new list of components
  /// filtered by [filter].

  void filter(String filter) {
    if (filter == _currentFilter) return;
    _currentFilter = filter;
    backend.postSearchQuery(new SearchQueryAddRequest()
      ..filter = filter
      ..type = SearchQueryType.FILTER);
    loadComponents(0);
  }

  /// Set sorting
  ///
  /// Set the current sorting and fetch a new list of components
  /// sorted by [filter].

  void setSort(String sortColumn) {
    if (sortColumn == _currentSort) return;
    _currentSort = sortColumn;
    _viewElement
        .querySelectorAll(".header-selected")
        .classes
        .remove("header-selected");
    _viewElement
        .querySelector(".$sortColumn-header")
        .classes
        .add("header-selected");
    loadComponents(0);
  }

  void onShow() {}

  void onHide() {}

  Element get element => _viewElement;

  Element _viewElement;
  Element _productItem;
  Element _productList;
  Element _pager;
  InputElement _filterField;
  Completer _selectComponentCompleter;
  String _currentType;
  String _currentFilter;
  String _currentSort;
  Configuration _currentConfiguration;
  int _currentPage;
  int _pageCount;
  int pageWidth = config["page-width"] ?? 5;
}
