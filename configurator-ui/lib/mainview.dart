import 'dart:html';
import 'package:uilib/view.dart';
import 'package:uilib/util.dart';
import 'pcbuilder.dart';
import 'package:pcbuilder.api/transport/configuration.dart';
import 'package:pcbuilder.api/transport/componentitem.dart';
import 'buyoverviewdialog.dart';
import 'package:pcbuilder.api/serializer.dart';

/// The main view displays the current configuration.

class MainView extends View {
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

  /// Get view id.
  ///
  /// Get the identifier for this view.

  static String get id => "mainview";

  /// Main view constructor.
  ///
  /// Initializes the view.

  MainView() {
    _view = querySelector("#mainview");
    Element template = _view.querySelector(".componentItem");
    _componentItem = template.clone(true);
    template.remove();

    // maak component types
    _buildComponentSelectors();

    // load persisted configuration
    _loadConfiguration();

    // clear current config
    _view.querySelector(".clearAction").onClick.listen((_){
      clearCurrentConfig();
    });

    // show buy screen
    _view.querySelector(".buyAction").onClick.listen((_){
      showBuySummary();
    });
  }

  /// Load configuration
  ///
  /// Load a saved configuration from the browser local storage if it exists.

  void _loadConfiguration() {
    if (window.localStorage.containsKey("configuration")) {
      _configuration = fromJson(window.localStorage["configuration"],new Configuration());
      if (_configuration == null) {
        _configuration = new Configuration();
      } else {
        updateComponentItem(_configuration.motherboard,"Motherboard");
        updateComponentItem(_configuration.cpu,"CPU");
        updateComponentItem(_configuration.gpu,"GPU");
        updateComponentItem(_configuration.memory,"Memory");
        updateComponentItem(_configuration.storage,"Storage");
        updateComponentItem(_configuration.psu,"PSU");
        updateComponentItem(_configuration.casing,"Case");
      }
    }
  }

  /// Build component selectors
  ///
  /// Generate the list of components the user can select.

  void _buildComponentSelectors() {
    Element componentContainer = querySelector("#pcconfiglist");

    for (String component in components) {
      Element e = _componentItem.clone(true);
      e.classes.add("component-${component.toLowerCase()}");
      e.querySelector(".type").text = component;

      e.querySelector(".selectComponent").onClick.listen((_) async {
        ComponentItem c = await pcbuilder.selectComponentView
            .selectComponent(component, _configuration);
        _onComponentSelected(c,component);
      });

      componentContainer.append(e);
    }
  }

  /// Handle component selection event.
  ///
  /// Displays the component info for the current selected component and
  /// updates and saves the current configuration.

  void _onComponentSelected(ComponentItem c, String component) {
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

    // persist configuration
    window.localStorage["configuration"] = toJson(_configuration);

    updateComponentItem(c,component);

    setPriceTotal();
  }

  /// Set price total.
  ///
  /// Update the price total.

  void setPriceTotal() {
    double price = _configuration.priceTotal();
    if (price == 0.0) {
      querySelector("#pricetotal span").text = "0.-";
    } else {
      querySelector("#pricetotal span").text = formatCurrency(price);
    }
  }

  /// Update component item
  ///
  /// Update the DOM element for the component.

  void updateComponentItem(ComponentItem c, String component) {
    Element e = _view.querySelector(".component-${component.toLowerCase()}");
    if (c == null) {
      e.querySelector(".name").text =
          _componentItem.querySelector(".name").text;
      e.querySelector(".price p").text =
          _componentItem.querySelector(".price p").text;
      e.querySelector(".image").setAttribute("style", "");
    } else {
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
    }
  }

  /// onShow event
  ///
  /// Event triggered when this view becomes the active view.

  void onShow() {}

  /// onHide event
  ///
  /// Event triggered when this view is no longer active.

  void onHide() {}

  /// Get view element
  ///
  /// Get the DOM element for this view.

  Element get element => _view;

  /// Remove component
  ///
  /// Remove a component by component type [component].

  void removeComponent(String component) {

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
    updateComponentItem(null,component);
    setPriceTotal();

    // persist configuration
    window.localStorage["configuration"] = toJson(_configuration);
  }

  /// Clear config
  ///
  /// Remove all components from the configuration.

  void clearCurrentConfig() {
    for (String component in components) {
      removeComponent(component);
    }
  }

  /// Show buy summary
  ///
  /// Open the buy overview dialog.

  void showBuySummary() {
    _buyOverviewDialog.show(_configuration);
  }

}
