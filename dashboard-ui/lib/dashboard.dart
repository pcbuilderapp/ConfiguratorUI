import 'dart:html';
import 'package:uilib/viewcontroller.dart';
import 'productview.dart';
import 'searchesview.dart';
import 'crawlerview.dart';
import 'package:pcbuilder.api/config.dart';
import 'package:pcbuilder.api/backend.dart';
import 'dart:async';

/// Get the dashboard instance.

final Dashboard dashboard = new Dashboard();

/// Dashboard represents the web application.

class Dashboard extends ViewController {

  /// Initialize the web app

  Future init() async {
    try {
      String yamlSrc = await HttpRequest.getString("config.yaml");
      config.init(yamlSrc);
    } catch (e) {
      print(e);
    }
    backend.onError.listen((error){
      window.alert(error);
    });
    registerView(ProductView.id, new ProductView(), isDefaultView: true);
    registerView(SearchesView.id, new SearchesView());
    registerView(CrawlerView.id, new CrawlerView());
    enableRouting();
  }
}
