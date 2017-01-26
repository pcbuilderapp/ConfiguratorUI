import 'package:uilib/view.dart';
import 'dart:html';
import 'dart:async';
import 'package:pcbuilder.api/config.dart';
import 'package:pcbuilder.api/backend.dart';
import 'package:uilib/util.dart';
import 'package:pcbuilder.api/transport/searchqueryrequest.dart';
import 'package:pcbuilder.api/transport/searchqueryresponse.dart';
import 'package:pcbuilder.api/domain/searchquery.dart';
import 'package:pcbuilder.api/domain/searchquerytype.dart';

class SearchesView extends View {
  Element _viewElement = querySelector("#searchesview");
  static String get id => "searchesview";

  void onShow() {
    querySelector("#searchesNav").classes.add("active");
  }

  void onHide() {
    querySelector("#searchesNav").classes.remove("active");
  }

  Element _searchesItem;
  Element _searchesList;
  Element _pager;
  InputElement _filterField;
  String _currentFilter="";
  String _currentSort;
  int _currentPage;
  int _pageCount;
  int pageWidth = config["page-width"] ?? 5;

  SearchesView() {
    Element template = _viewElement.querySelector(".searchesItem");
    _searchesItem = template.clone(true);
    template.remove();
    _filterField = _viewElement.querySelector(".searchbar input") as InputElement;
    _filterField.onSearch.listen((_) {
      filter(_filterField.value);
    });
    
    _searchesList = _viewElement.querySelector("#searchesList");
    (_viewElement.querySelector(".searchbar form") as FormElement)
        .onSubmit
        .listen((Event e) {
      filter(_filterField.value);
      e.preventDefault();
    });
/*
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
*/
    _pager = _viewElement.querySelector(".pager");
    _pager.querySelector(".previous").onClick.listen((_) {
      if (_currentPage <= 1) return;
      loadSearches(_currentPage - 1);
    });

    _pager.querySelector(".next").onClick.listen((_) {
      if (_currentPage >= _pageCount) return;
      loadSearches(_currentPage + 1);
    });

    loadSearches(0);
  }

  Future loadSearches(int page) async {
    // show load indicator
    _viewElement.querySelector(".content").style.display = "none";
    _viewElement.querySelector(".loading").style.display = "block";

    SearchQueryRequest searchQueryRequest = new SearchQueryRequest();
    searchQueryRequest.filter = _currentFilter;
    searchQueryRequest.page = page;
    searchQueryRequest.maxItems = config["max-items"] ?? 30;
    searchQueryRequest.sort = _currentSort;

    SearchQueryResponse searchQueryResponse =
    await backend.getSearches(searchQueryRequest);

    _searchesList.innerHtml = "";

    // generate searches list
    for (SearchQuery s in searchQueryResponse.searches) {
      _searchesList.append(createsearchesElement(s));
    }

    // set paging
    _currentPage = searchQueryResponse.page;
    _pageCount = searchQueryResponse.pageCount;
    Element pages = _pager.querySelector(".pages");
    pages.innerHtml = "";

    bool lastAddedPoints = false;

    for (int i = 0; i < searchQueryResponse.pageCount; i++) {
      if (showpage(i, searchQueryResponse.page, pageWidth,
          searchQueryResponse.pageCount - 1)) {
        Element pagebtn = new Element.div();
        pagebtn.text = "${i + 1}";
        pagebtn.classes.add("pagebtn");

        if (i == searchQueryResponse.page) {
          pagebtn.classes.add("current");
        } else {
          pagebtn.onClick.listen((_) {
            loadSearches(i);
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

  Element createsearchesElement(SearchQuery item) {
    Element e = _searchesItem.clone(true);

    // searches row
    e.querySelector(".filter").text = item.filter;
    e.querySelector(".type").text = searchQueryType(item.type);
    e.querySelector(".component").text = item.component.name;
    e.querySelector(".count").text = "${item.count}";

    // actions
    /*e.onClick.listen((_) {
      // load details
      //loadSearchesDetail(item);
    });*/

    return e;
  }

  void filter(String filter) {
    if (filter == _currentFilter) return;
    _currentFilter = filter;
    loadSearches(0);
  }

  void setSort(String sortColumn) {
    if (sortColumn == _currentSort) return;
    _currentSort = sortColumn;
    _viewElement.querySelectorAll(".header-selected").classes.remove("header-selected");
    _viewElement.querySelector(".$sortColumn-header").classes.add("header-selected");
    loadSearches(0);
  }

  Element get element => _viewElement;
}
