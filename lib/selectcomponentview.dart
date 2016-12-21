import 'dart:async';
import 'view.dart';
import 'dart:html';
import 'config.dart';
import 'component.dart';
import 'componentmatchingsearch.dart';
import 'dart:convert';
import 'configuration.dart';

class SelectComponentView extends View {
  SelectComponentView() {
    _viewElement = querySelector("#selectview");
    _filterField = querySelector("#searchbar input") as InputElement;
    (querySelector("#searchbar form") as FormElement).onSubmit.listen((Event e){
      filter(_filterField.value);
      e.preventDefault();
    });
  }

  Future<Component> selectComponent(String componentType, Configuration configuration) {
    _selectComponentCompleter = new Completer();
    show();

    ComponentMatchingSearch search =  new ComponentMatchingSearch();
    search.type = componentType;
    search.filter = _filterField.value;
    search.configuration = configuration;
/*
    String data = (new JsonEncoder()).convert(search);
    HttpRequest.postFormData(BACKEND_SERVER + "component/getmatchingcomponents",
        {"request": data}).then((HttpRequest request) {
      //request.responseText
    });
*/


    return _selectComponentCompleter.future;
  }

  void filter(String filter) {

  }

  Element get element => _viewElement;

  Element _viewElement;
  InputElement _filterField;
  Completer _selectComponentCompleter;
}
