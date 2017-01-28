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
    Element template = _viewElement.querySelector(".crawleritem");
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
    crawlerContainer.innerHtml = "";
    CrawlerResponse crawlerResponse = await backend.getCrawlers();

    for (Crawler crawler in crawlerResponse.crawlers) {

      Element c  = _crawlertItem.clone(true);
      c.querySelector(".name").text = crawler.name;

      Element activeIndicator = c.querySelector(".switch");
      Element activate = c.querySelector(".hover .activate");
      Element deactivate = c.querySelector(".hover .deactivate");

      if (crawler.activated) {

        activeIndicator..text = "Active"..style.color = "#349e34";
        activate.style.display = "none";
        deactivate..style.display = "block"..onClick.listen((_) async {
          crawler.activated = false;
          await backend.updateCrawler(crawler);
          loadCrawlers();
        });

      } else {

        activeIndicator..text = "Inactive"..style.color = "#9e3434";
        deactivate.style.display = "none";
        activate..style.display = "block"..onClick.listen ((_) async {
          crawler.activated = true;
          await backend.updateCrawler(crawler);
          loadCrawlers();
        });
      }

      crawlerContainer.append(c);
    }

    // hide load indicator
    _viewElement.querySelector(".content").style.display = "block";
    _viewElement.querySelector(".loading").style.display = "none";
  }
}
