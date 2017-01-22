import 'dart:html';
import 'package:uilib/view.dart';
import 'package:uilib/util.dart';
import 'pcbuilder.dart';
import 'package:pcbuilder.api/transport/configuration.dart';
import 'package:pcbuilder.api/transport/componentitem.dart';
import 'buyoverviewdialog.dart';

class MainView extends View {
  static String get id => "mainview";

  Element _view;
  Element _componentItem;
  Configuration _configuration = new Configuration();
  BuyOverviewDialog _buyOverviewDialog = new BuyOverviewDialog();
  final List<String> components = [
    "Motherboard",
    "CPU",
    "GPU",
    "Memory",
    "Storage",
    "PSU",
    "Case"
  ];

  MainView() {
    _view = querySelector("#mainview");
    Element template = _view.querySelector(".componentItem");
    _componentItem = template.clone(true);
    template.remove();

    // maak component types
    Element componentContainer = querySelector("#pcconfiglist");

    for (String component in components) {
      Element e = _componentItem.clone(true);
      e.classes.add("component-${component.toLowerCase()}");
      e.querySelector(".type").text = component;
      /*e.querySelector(".image").style.backgroundImage =
          "url(" + getDefaultImage(component) + ")";*/

      e.querySelector(".selectComponent").onClick.listen((_) async {
        ComponentItem c = await pcbuilder.selectComponentView
            .selectComponent(component, _configuration);
        pcbuilder.setView(MainView.id);

        if (component == "Motherboard") {
          _configuration.motherboard = c;
        } else if (component == "CPU") {
          _configuration.cpu = c;
        } else if (component == "GPU") {
          _configuration.gpu = c;
        } else if (component == "Memory") {
          _configuration.memory = c;
        } else if (component == "Storage") {
          _configuration.storage = c;
        } else if (component == "PSU") {
          _configuration.psu = c;
        } else if (component == "Case") {
          _configuration.casing = c;
        }

        e.querySelector(".name").text = c.name;
        e.querySelector(".price p").text = formatCurrency(c.price);
        e.querySelector(".image").style.backgroundImage = "url(${c.image})";

        // enable remove

        Element rmComponentElement = e.querySelector(".rmComponent");
        rmComponentElement
          ..style.display = "block"
          ..onClick.listen((_) {
            removeComponent(component);
            rmComponentElement.style.display = "none";
          });
        setPriceTotal();
      });

      componentContainer.append(e);
    }

    // clear current config
    _view.querySelector(".clearAction").onClick.listen((_){
      clearCurrentConfig();
    });

    // show buy screen
    _view.querySelector(".buyAction").onClick.listen((_){
      showBuySummary();
    });
  }

  void setPriceTotal() {
    // update price
    double price = _configuration.priceTotal();
    if (price == 0.0) {
      querySelector("#pricetotal span").text = "0.-";
    } else {
      querySelector("#pricetotal span").text = formatCurrency(price);
    }
  }

  void onShow() {}

  void onHide() {}

  Element get element => _view;

  String getDefaultImage(component) {
    if (component == "Motherboard") {
      return "./images/motherboard.png";
    } else if (component == "CPU") {
      return "./images/cpu.png";
    } else if (component == "GPU") {
      return "./images/gpu.png";
    } else if (component == "Memory") {
      return "./images/mem.png";
    } else if (component == "Storage") {
      return "./images/storage.png";
    } else if (component == "PSU") {
      return "./images/psu.png";
    } else if (component == "Case") {
      return "./images/case.png";
    } else {
      return "";
    }
  }

  void removeComponent(String component) {
    Element e = _view.querySelector(".component-${component.toLowerCase()}");
    if (component == "Motherboard") {
      _configuration.motherboard = null;
    } else if (component == "CPU") {
      _configuration.cpu = null;
    } else if (component == "GPU") {
      _configuration.gpu = null;
    } else if (component == "Memory") {
      _configuration.memory = null;
    } else if (component == "Storage") {
      _configuration.storage = null;
    } else if (component == "PSU") {
      _configuration.psu = null;
    } else if (component == "Case") {
      _configuration.casing = null;
    }
    e.querySelector(".name").text =
        _componentItem.querySelector(".name").text;
    e.querySelector(".price p").text =
        _componentItem.querySelector(".price p").text;
    e.querySelector(".image").setAttribute("style", "");
    setPriceTotal();
  }

  void clearCurrentConfig() {
    for (String component in components) {
      removeComponent(component);
    }
  }

  void showBuySummary() {
    _buyOverviewDialog.show(_configuration);
  }

}
