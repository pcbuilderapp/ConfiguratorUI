import 'package:uilib/view.dart';
import 'dart:html';
import 'dart:async';
import 'package:pcbuilder.api/config.dart';
import 'package:pcbuilder.api/transport/productsearch.dart';
import 'package:pcbuilder.api/transport/productsresponse.dart';
import 'package:pcbuilder.api/domain/product.dart';
import 'package:pcbuilder.api/backend.dart';
import 'package:uilib/util.dart';
import 'package:uilib/charts.dart';
import 'package:pcbuilder.api/transport/pricehistoryresponse.dart';
import 'package:pcbuilder.api/transport/pricehistoryrequest.dart';

class ProductView extends View {
  Element _viewElement = querySelector("#productview");
  static String get id => "productview";
  Element _productItem;
  Element _productList;
  Element _productInfo;
  Element _pager;
  InputElement _filterField;
  String _currentFilter="";
  String _currentSort;
  int _currentPage;
  int _pageCount;
  int pageWidth = config["page-width"] ?? 5;

  ProductView() {
    Element template = _viewElement.querySelector(".productItem");
    _productItem = template.clone(true);
    template.remove();
    _filterField = _viewElement.querySelector(".searchbar input") as InputElement;
    _filterField.onSearch.listen((_) {
      filter(_filterField.value);
    });

    _productInfo = _viewElement.querySelector(".productInfo");

    _productList = _viewElement.querySelector("#productList");
    (_viewElement.querySelector(".searchbar form") as FormElement)
        .onSubmit
        .listen((Event e) {
      filter(_filterField.value);
      e.preventDefault();
    });
    
    _viewElement.querySelector("thead .name").onClick.listen((MouseEvent e) {
      setSort("name");
    });
    _viewElement.querySelector("thead .shop").onClick.listen((MouseEvent e) {
      setSort("shop");
    });
    _viewElement.querySelector("thead .type").onClick.listen((MouseEvent e) {
      setSort("type");
    });
    _viewElement.querySelector("thead .price").onClick.listen((MouseEvent e) {
      setSort("price");
    });

    _pager = _viewElement.querySelector(".pager");
    _pager.querySelector(".previous").onClick.listen((_) {
      if (_currentPage <= 1) return;
      loadProducts(_currentPage - 1);
    });

    _pager.querySelector(".next").onClick.listen((_) {
      if (_currentPage >= _pageCount) return;
      loadProducts(_currentPage + 1);
    });

    loadProducts(0);
  }

  void onShow() {
    querySelector("#productsNav").classes.add("active");
  }

  void onHide() {
    querySelector("#productsNav").classes.remove("active");
  }

  Future loadProducts(int page) async {
    // show load indicator
    _viewElement.querySelector(".content").style.display = "none";
    _viewElement.querySelector(".loading").style.display = "block";

    ProductSearch productSearch = new ProductSearch();
    productSearch.filter = _currentFilter;
    productSearch.page = page;
    productSearch.maxItems = config["max-items"] ?? 30;
    productSearch.sort = _currentSort;

    ProductsResponse productSearchResponse =
    await backend.getProducts(productSearch);

    _productList.innerHtml = "";

    // generate product list
    for (Product p in productSearchResponse.products) {
      _productList.append(createProductElement(p));
    }

    // set paging
    _currentPage = productSearchResponse.page;
    _pageCount = productSearchResponse.pageCount;
    Element pages = _pager.querySelector(".pages");
    pages.innerHtml = "";

    bool lastAddedPoints = false;

    for (int i = 0; i < productSearchResponse.pageCount; i++) {
      if (showpage(i, productSearchResponse.page, pageWidth,
          productSearchResponse.pageCount - 1)) {
        Element pagebtn = new Element.div();
        pagebtn.text = "${i + 1}";
        pagebtn.classes.add("pagebtn");

        if (i == productSearchResponse.page) {
          pagebtn.classes.add("current");
        } else {
          pagebtn.onClick.listen((_) {
            loadProducts(i);
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

  Element createProductElement(Product item) {
    Element e = _productItem.clone(true);

    // product row
    e.querySelector(".name").text = item.component.name;
    e.querySelector(".type").text = item.component.type;
    e.querySelector(".shop").text = item.shop.name;
    e.querySelector(".price").text = formatCurrency(item.currentPrice);

    // actions
    e.onClick.listen((_) {
      // load details
      loadProductDetail(item);
    });

    return e;
  }

  Future loadProductDetail(Product p) async {

    // product detail view
    _productInfo.querySelector(".info .ean-nr").text =
        p.component.europeanArticleNumber;
    _productInfo.querySelector(".info .mpn-nr").text =
        p.component.manufacturerPartNumber;
    _productInfo.querySelector(".image").style.backgroundImage =
    "url(${p.component.pictureUrl})";

    Element priceHistory = _productInfo.querySelector(".pricehistory");
    priceHistory.style.display = "block";
    priceHistory.innerHtml = "";

    PriceHistoryRequest priceHistoryRequest = new PriceHistoryRequest();
    priceHistoryRequest.componentId = p.component.id;

    priceHistoryRequest.min = true;
    PriceHistoryResponse minDailyPriceViewResponse =
      await backend.getPriceHistory(priceHistoryRequest);

    priceHistoryRequest.min = false;
    PriceHistoryResponse maxDailyPriceViewResponse =
      await backend.getPriceHistory(priceHistoryRequest);

    drawPriceHistoryChart(minDailyPriceViewResponse.priceHistory, maxDailyPriceViewResponse.priceHistory, priceHistory);

    /*if (p.component.connectors.length != 0) {
      Element connectorsElement = _productInfo.querySelector(".connectors");

      for (Connector c in p.component.connectors) {
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
    }*/

  }

  void filter(String filter) {
    if (filter == _currentFilter) return;
    _currentFilter = filter;
    loadProducts(0);
  }

  void setSort(String sortColumn) {
    if (sortColumn == _currentSort) return;
    _currentSort = sortColumn;
    _viewElement.querySelectorAll(".header-selected").classes.remove("header-selected");
    _viewElement.querySelector(".$sortColumn-header").classes.add("header-selected");
    loadProducts(0);
  }

  Element get element => _viewElement;
}
