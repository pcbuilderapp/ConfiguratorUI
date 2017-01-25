import 'package:uilib/view.dart';
import 'dart:html';
import 'package:pcbuilder.api/backend.dart';
import 'package:pcbuilder.api/transport/crawlerresponse.dart';
import 'package:pcbuilder.api/domain/crawler.dart';

class CrawlersView extends View {
  Element _element = querySelector("#crawlersview");
  Element _crawlerContainer = querySelector("#crawlerlist");
  static String get id => "crawlersview";

  Element _crawlertItem;

  CrawlersView() {
    Element template = _element.querySelector(".crawlerItem");
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

  Element get element => _element;

  loadCrawlers() async {
    CrawlerResponse crawlerResponse = await backend.getCrawlers();
    for (Crawler crawler in crawlerResponse.crawlers) {
      Element c  = _crawlertItem.clone(true);
      c.querySelector(".name").text = crawler.name;
      c.querySelector(".switch").text = crawler.activated ? "Active" : "Inactive";
      _crawlerContainer.append(c);
    }
  }
}
