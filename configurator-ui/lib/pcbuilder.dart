import 'mainview.dart';
import 'selectcomponentview.dart';
import 'package:uilib/viewcontroller.dart';
import 'package:pcbuilder.api/config.dart';
import 'dart:html';
import 'dart:async';

PCBuilder pcbuilder = new PCBuilder();

class PCBuilder extends ViewController {
  Future init() async {
    try {
      String yamlSrc = await HttpRequest.getString("config.yaml");
      config.init(yamlSrc);
    } catch (e) {
      print(e);
    }
    _mainView = registerView(MainView.id, new MainView(), isDefaultView: true)
        as MainView;
    _selectComponentView =
        registerView(SelectComponentView.id, new SelectComponentView())
            as SelectComponentView;
  }

  MainView get mainView => _mainView;
  SelectComponentView get selectComponentView => _selectComponentView;

  MainView _mainView;
  SelectComponentView _selectComponentView;
}
