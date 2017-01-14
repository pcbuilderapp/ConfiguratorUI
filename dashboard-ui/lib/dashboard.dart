import 'dart:html';
import 'package:uilib/viewcontroller.dart';
import 'productview.dart';
import 'searchesview.dart';

final Dashboard dashboard = new Dashboard();

class Dashboard extends ViewController {
  void init() {
    registerView(ProductView.id,new ProductView(),isDefaultView: true);
    registerView(SearchesView.id,new SearchesView());
    enableRouting();
  }


}