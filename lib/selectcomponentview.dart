import 'dart:async';
import 'view.dart';
import 'dart:html';
import 'config.dart';
import 'component.dart';
import 'componentmatchingsearch.dart';
import 'dart:convert';
import 'configuration.dart';
import 'backend.dart';

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
  }

  Future<Component> selectComponent(String componentType, Configuration configuration) async {
    _selectComponentCompleter = new Completer();
    show();

    // show load indicator

    ComponentMatchingSearch search =  new ComponentMatchingSearch();
    search.type = componentType;
    search.filter = _filterField.value;
    search.configuration = configuration;

    GetMatchingComponentsResponds responds = await backend.getMatchingComponents(search);
    _productList.innerHtml = "";

    // generate product list

    for (Component c in responds.components) {
      Element item = _productItem.clone(true);

      // product row

      item.querySelector(".fields .name").text = c.name;
      item.querySelector(".fields .shop").text = c.shop;
      item.querySelector(".fields .price").text = "€ ${c.price}";

      // product detail view

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
