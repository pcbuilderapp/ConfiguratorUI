import 'mainview.dart';
import 'selectcomponentview.dart';

PCBuilder pcbuilder = new PCBuilder();

class PCBuilder {
  void init() {
    _mainView = new MainView();
    _selectComponentView = new SelectComponentView();
  }

  MainView get mainView => _mainView;
  SelectComponentView get selectComponentView => _selectComponentView;

  MainView _mainView;
  SelectComponentView _selectComponentView;
}