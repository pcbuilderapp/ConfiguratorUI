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
  Element _searchesItem;
  Element _searchesList;
  Element _pager;
  InputElement _filterField;
  String _currentFilter = "";
  String _currentSort = "count";
  int _currentPage;
  int _pageCount;
  int pageWidth = config["page-width"] ?? 5;

  /// Get view id.
  ///
  /// Get the identifier for this view.

  static String get id => "searchesview";

  /// onShow event
  ///
  /// Event triggered when this view becomes the active view.

  void onShow() {
    querySelector("#searchesNav").classes.add("active");
    loadSearches(0);
  }

  /// onHide event
  ///
  /// Event triggered when this view is no longer active.

  void onHide() {
    querySelector("#searchesNav").classes.remove("active");
  }

  /// Search view constructor.
  ///
  /// Initializes the view.

  SearchesView() {
    Element template = _viewElement.querySelector(".searchesItem");
    _searchesItem = template.clone(true);
    template.remove();
    _filterField =
        _viewElement.querySelector(".searchbar input") as InputElement;
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

    _viewElement.querySelector("thead .filter").onClick.listen((MouseEvent e) {
      setSort("filter");
    });
    _viewElement.querySelector("thead .type").onClick.listen((MouseEvent e) {
      setSort("type");
    });
    _viewElement
        .querySelector("thead .component")
        .onClick
        .listen((MouseEvent e) {
      setSort("component");
    });
    _viewElement.querySelector("thead .count")
      ..onClick.listen((MouseEvent e) {
        setSort("count");
      })
      ..classes.add("header-selected");

    _pager = _viewElement.querySelector(".pager");
    _pager.querySelector(".previous").onClick.listen((_) {
      if (_currentPage <= 1) return;
      loadSearches(_currentPage - 1);
    });

    _pager.querySelector(".next").onClick.listen((_) {
      if (_currentPage >= _pageCount) return;
      loadSearches(_currentPage + 1);
    });
  }

  /// Load searches.
  ///
  /// Get all the search queries with set filters for page [page].

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
      _searchesList.append(createSearchesElement(s));
    }

    // set paging
    _currentPage = searchQueryResponse.page;
    _pageCount = searchQueryResponse.pageCount;
    createPaging(searchQueryResponse);

    // hide load indicator
    _viewElement.querySelector(".content").style.display = "block";
    _viewElement.querySelector(".loading").style.display = "none";
  }

  /// Create searches element.
  ///
  /// Create DOM element for the given [item].

  Element createSearchesElement(SearchQuery item) {
    Element e = _searchesItem.clone(true);

    // searches row
    e.querySelector(".filter").text = item.filter;
    e.querySelector(".type").text = "${item.type}";
    e.querySelector(".component").text = item.component?.name ?? "-";
    e.querySelector(".count").text = "${item.count}";

    // actions
    /*e.onClick.listen((_) {
      // load details
      //loadSearchesDetail(item);
    });*/

    return e;
  }

  /// Create paging
  ///
  /// Update the pager with the current page index and count.

  void createPaging(SearchQueryResponse searchQueryResponse) {
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
  }

  /// Set filter
  ///
  /// Set the current filter and fetch a new list of products
  /// filtered by [filter].

  void filter(String filter) {
    if (filter == _currentFilter) return;
    _currentFilter = filter;
    loadSearches(0);
  }

  /// Set sorting
  ///
  /// Set the current sorting and fetch a new list of products
  /// sorted by [filter].

  void setSort(String sortColumn) {
    if (sortColumn == _currentSort) {
      _currentSort = "!$sortColumn";
    } else {
      _currentSort = sortColumn;
    }
    _viewElement
        .querySelectorAll(".header-selected")
        .classes
        .remove("header-selected");
    _viewElement
        .querySelector("th.$sortColumn")
        .classes
        .add("header-selected");
    loadSearches(0);
  }

  /// Get view element
  ///
  /// Get the DOM element for this view.

  Element get element => _viewElement;
}
