library PCBuilder;

import 'dart:html';
import 'view.dart';

class MainView extends View {
  MainView() {
    _view = querySelector("#mainview");
  }


  Element get element => _view;

  Element _view;
}