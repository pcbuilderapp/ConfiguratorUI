import 'dart:html';
import 'package:uilib/view.dart';
import 'package:uilib/util.dart';
import 'pcbuilder.dart';
import 'package:pcbuilder.api/transport/configuration.dart';
import 'package:pcbuilder.api/transport/componentitem.dart';
import 'package:pcbuilder.api/domain/ctype.dart';
import 'buyoverviewdialog.dart';
import 'package:pcbuilder.api/serializer.dart';

/// The main view displays the current configuration.

class MainView extends View {
  Element _view;
  Element _componentItem;
  Configuration _configuration = new Configuration();
  BuyOverviewDialog _buyOverviewDialog = new BuyOverviewDialog();
  final List<CType> components = [
    CType.MOTHERBOARD,
    CType.CPU,
    CType.GPU,
    CType.MEMORY,
    CType.STORAGE,
    CType.PSU,
    CType.CASE
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
        updateComponentItem(_configuration.motherboard,CType.MOTHERBOARD);
        updateComponentItem(_configuration.cpu,CType.CPU);
        updateComponentItem(_configuration.gpu,CType.GPU);
        updateComponentItem(_configuration.memory,CType.MEMORY);
        updateComponentItem(_configuration.storage,CType.STORAGE);
        updateComponentItem(_configuration.psu,CType.PSU);
        updateComponentItem(_configuration.casing,CType.CASE);
      }
    }
  }

  /// Build component selectors
  ///
  /// Generate the list of components the user can select.

  void _buildComponentSelectors() {
    Element componentContainer = querySelector("#pcconfiglist");

    for (CType component in components) {
      Element e = _componentItem.clone(true);
      e.classes.add("component-${component.toString().toLowerCase()}");
      e.querySelector(".type").text = getTypeName(component);

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

  void _onComponentSelected(ComponentItem c, CType component) {
    pcbuilder.setView(MainView.id);

    if (component == CType.MOTHERBOARD) {
      _configuration.motherboard = c;
    } else if (component == CType.CPU) {
      _configuration.cpu = c;
    } else if (component == CType.GPU) {
      _configuration.gpu = c;
    } else if (component == CType.MEMORY) {
      _configuration.memory = c;
    } else if (component == CType.STORAGE) {
      _configuration.storage = c;
    } else if (component == CType.PSU) {
      _configuration.psu = c;
    } else if (component == CType.CASE) {
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

  void updateComponentItem(ComponentItem c, CType component) {
    Element e = _view.querySelector(".component-${component.toString().toLowerCase()}");
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

  void removeComponent(CType component) {

    if (component == CType.MOTHERBOARD) {
      _configuration.motherboard = null;
    } else if (component == CType.CPU) {
      _configuration.cpu = null;
    } else if (component == CType.GPU) {
      _configuration.gpu = null;
    } else if (component == CType.MEMORY) {
      _configuration.memory = null;
    } else if (component == CType.STORAGE) {
      _configuration.storage = null;
    } else if (component == CType.PSU) {
      _configuration.psu = null;
    } else if (component == CType.CASE) {
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
    for (CType component in components) {
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
