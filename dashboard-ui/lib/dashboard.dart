import 'dart:html';
import 'package:uilib/viewcontroller.dart';
import 'productview.dart';
import 'searchesview.dart';
import 'crawlerview.dart';
import 'package:pcbuilder.api/config.dart';
import 'dart:async';

final Dashboard dashboard = new Dashboard();

class Dashboard extends ViewController {
  Future init() async {
    try {
      String yamlSrc = await HttpRequest.getString("config.yaml");
      config.init(yamlSrc);
    } catch (e) {
      print(e);
    }
    registerView(ProductView.id, new ProductView(), isDefaultView: true);
    registerView(SearchesView.id, new SearchesView());
    registerView(CrawlerView.id, new CrawlerView());
    enableRouting();
  }
}
