import 'package:uilib/view.dart';
import 'dart:html';
import 'package:pcbuilder.api/backend.dart';
import 'package:pcbuilder.api/transport/crawlerresponse.dart';
import 'package:pcbuilder.api/domain/crawler.dart';

class CrawlersView extends View {

  Element _viewElement = querySelector("#crawlersview");
  static String get id => "crawlersview";
  Element _crawlertItem;

  Element get element => _viewElement;

  CrawlersView() {
    Element template = _viewElement.querySelector(".crawlerItem");
    _crawlertItem = template.clone(true);
    template.remove();
    loadCrawlers();
  }

  void onShow() {
    querySelector("#crawlersNav").classes.add("active");
  }

  void onHide() {
    querySelector("#crawlersNav").classes.remove("active");
  }

  loadCrawlers() async {
    // show load indicator
    _viewElement.querySelector(".content").style.display = "none";
    _viewElement.querySelector(".loading").style.display = "block";

    Element crawlerContainer  = querySelector(".crawlerlist");
    CrawlerResponse crawlerResponse = await backend.getCrawlers();

    for (Crawler crawler in crawlerResponse.crawlers) {
      Element c  = _crawlertItem.clone(true);
      c.querySelector(".name").text = crawler.name;
      c.querySelector(".switch").text = crawler.activated ? "Active" : "Inactive";
      crawlerContainer.append(c);
    }

    // hide load indicator
    _viewElement.querySelector(".content").style.display = "block";
    _viewElement.querySelector(".loading").style.display = "none";
  }
}
