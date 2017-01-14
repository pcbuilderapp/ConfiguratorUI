library uilib.viewcontroller;

import 'view.dart';
import 'dart:async';
import 'package:route_hierarchical/client.dart';

class ViewController {
  Router _router=new Router();
  String _currentViewId;
  Map<String,View> _viewRegistry = {};

  void enableRouting() {
    _router.listen();
  }

  void setView(String id) {
    View view = _viewRegistry[id];
    if (view == null) throw "Invalid id.";
    _viewRegistry[_currentViewId]?.hide();
    _currentViewId = id;
    view.show();
  }

  String get currentViewId => _currentViewId;
  View get currentView => _viewRegistry[_currentViewId];

  View registerView(String id, View view, {bool isDefaultView:false}) {
    _viewRegistry[id] = view;
    _router.root.addRoute(name: id,path:"/$id",defaultRoute: isDefaultView,enter: (_){
      setView(id);
    });
    return view;
  }

  Stream<RouteStartEvent> get onRouteStart => _router.onRouteStart;
}