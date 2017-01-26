import 'package:uilib/view.dart';
import 'dart:html';
import 'package:pcbuilder.api/backend.dart';
import 'package:pcbuilder.api/transport/crawlerresponse.dart';
import 'package:pcbuilder.api/domain/crawler.dart';

class CrawlerView extends View {

  Element _viewElement = querySelector("#crawlerview");
  static String get id => "crawlerview";
  Element _crawlertItem;

  Element get element => _viewElement;

  CrawlerView() {
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

      if (crawler.activated) {
        c.querySelector(".switch").text = "Active";
        c.querySelector(".hover .activate").style.display = "none";
        c.querySelector(".hover .deactivate").style.display = "block";
      } else {
        c.querySelector(".switch").text = "Inactive";
        c.querySelector(".hover .activate").style.display = "block";
        c.querySelector(".hover .deactivate").style.display = "none";
      }

      crawlerContainer.append(c);

    }

    // hide load indicator
    _viewElement.querySelector(".content").style.display = "block";
    _viewElement.querySelector(".loading").style.display = "none";
  }
}
