import 'package:uilib/view.dart';
import 'dart:html';
import 'package:pcbuilder.api/backend.dart';
import 'package:pcbuilder.api/transport/crawlerresponse.dart';
import 'package:pcbuilder.api/domain/crawler.dart';

/// The crawlerview lists the current registered crawlers.

class CrawlerView extends View {
  Element _viewElement = querySelector("#crawlerview");
  Element _crawlertItem;

  static String get id => "crawlerview";

  /// Initialize the view.

  CrawlerView() {
    Element template = _viewElement.querySelector(".crawleritem");
    _crawlertItem = template.clone(true);
    template.remove();
    loadCrawlers();
  }

  /// Get view element
  ///
  /// Get the DOM element for this view.

  Element get element => _viewElement;

  /// onShow event
  ///
  /// Event triggered when this view becomes the active view.

  void onShow() {
    querySelector("#crawlersNav").classes.add("active");
  }

  /// onHide event
  ///
  /// Event triggered when this view is no longer active.

  void onHide() {
    querySelector("#crawlersNav").classes.remove("active");
  }

  /// Get the crawlers and display them.

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
