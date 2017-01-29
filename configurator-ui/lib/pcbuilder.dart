import 'mainview.dart';
import 'selectcomponentview.dart';
import 'package:uilib/viewcontroller.dart';
import 'package:pcbuilder.api/config.dart';
import 'dart:html';
import 'dart:async';
import 'helpdialog.dart';

/// The [PCBuilder] singleton instance.

PCBuilder pcbuilder = new PCBuilder();

/// PCBuilder represents the web application.

class PCBuilder extends ViewController {
  HelpDialog _helpDialog = new HelpDialog();
  MainView _mainView;
  SelectComponentView _selectComponentView;

  /// Initialize the web app

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

  /// Get the main view.

  MainView get mainView => _mainView;

  /// Get the component selection view.

  SelectComponentView get selectComponentView => _selectComponentView;

  /// Show the help dialog.

  void showHelp() {
    _helpDialog.show();
  }
}
