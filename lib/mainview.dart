import 'dart:html';
import 'view.dart';
import 'pcbuilder.dart';
import 'configuration.dart';
import 'dart:async';
import 'component.dart';

class MainView extends View {
  MainView() {
    _view = querySelector("#mainview");
    _componentItem = _view.querySelector(".componentItem").clone(true);
    _view.querySelector(".componentItem").remove();

    // maak component types
    Element componentContainer = querySelector("#pcconfiglist");
    var components = [
      "Motherboard",
      "CPU",
      "GPU",
      "Memory",
      "Storage",
      "PSU",
      "Case"
    ];
    for (String component in components) {
      Element e = _componentItem.clone(true);

      e.querySelector(".type").text = component;
      e.onClick.listen((_) async {
        Component c = await pcbuilder.selectComponentView
            .selectComponent(component.toLowerCase(), _configuration);

        e.querySelector(".name").text = c.name;
        e.querySelector(".price p").text = "€ ${c.price}";
      });

      componentContainer.append(e);
    }
  }

  Element get element => _view;

  Element _view;
  Element _componentItem;
  Map<String, Element> _components;
  Configuration _configuration = new Configuration();
}
