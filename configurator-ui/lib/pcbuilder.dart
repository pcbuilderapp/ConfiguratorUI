import 'mainview.dart';
import 'selectcomponentview.dart';
import 'package:uilib/viewcontroller.dart';

PCBuilder pcbuilder = new PCBuilder();

class PCBuilder extends ViewController {
  void init() {
    _mainView = registerView(MainView.id,new MainView()) as MainView;
    _selectComponentView = registerView(SelectComponentView.id,new SelectComponentView()) as SelectComponentView;
  }

  MainView get mainView => _mainView;
  SelectComponentView get selectComponentView => _selectComponentView;

  MainView _mainView;
  SelectComponentView _selectComponentView;
}