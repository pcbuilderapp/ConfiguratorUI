import 'mainview.dart';
import 'selectcomponentview.dart';
import 'package:uilib/viewcontroller.dart';
import 'package:pcbuilder.api/config.dart';
import 'dart:html';
import 'dart:async';
import 'helpdialog.dart';

PCBuilder pcbuilder = new PCBuilder();

class PCBuilder extends ViewController {
  HelpDialog _helpDialog = new HelpDialog();

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

    querySelector("#helpBtn").onClick.listen((_)=>showHelp());
  }

  MainView get mainView => _mainView;
  SelectComponentView get selectComponentView => _selectComponentView;

  MainView _mainView;
  SelectComponentView _selectComponentView;

  void showHelp() {
    _helpDialog.show();
  }
}
