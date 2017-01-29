library uilib.viewcontroller;

import 'view.dart';
import 'dart:async';
import 'package:route_hierarchical/client.dart';

/// View controller handles the routing and displaying of the registered views.

class ViewController {
  Router _router = new Router();
  String _currentViewId;
  Map<String, View> _viewRegistry = {};

  /// Enable routing.
  ///
  /// Start listing for routing events.

  void enableRouting() {
    _router.listen();
  }

  /// Set the active view.

  void setView(String id) {
    View view = _viewRegistry[id];
    if (view == null) throw "Invalid id.";
    _viewRegistry[_currentViewId].hide();
    _currentViewId = id;
    view.show();
  }

  /// Get the current active view id.

  String get currentViewId => _currentViewId;

  /// Get the current active view.

  View get currentView => _viewRegistry[_currentViewId];

  /// Register a new view.

  View registerView(String id, View view, {bool isDefaultView: false}) {
    _viewRegistry[id] = view;
    if (isDefaultView) _currentViewId = id;
    _router.root.addRoute(
        name: id,
        path: "/$id",
        defaultRoute: isDefaultView,
        enter: (_) {
          setView(id);
        });
    return view;
  }

  Stream<RouteStartEvent> get onRouteStart => _router.onRouteStart;
}
