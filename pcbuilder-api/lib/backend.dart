import 'dart:async';
import 'dart:html';
import 'transport/componentmatchingsearch.dart';
import 'transport/matchingcomponentsresponse.dart';
import 'transport/productsresponse.dart';
import 'transport/productsearch.dart';
import 'config.dart';
import 'serializer.dart';
import 'package:pcbuilder.api/transport/pricehistoryresponse.dart';
import 'package:pcbuilder.api/transport/pricehistoryrequest.dart';
import 'package:pcbuilder.api/transport/crawlerresponse.dart';
import 'package:pcbuilder.api/domain/crawler.dart';
import 'package:pcbuilder.api/transport/searchqueryrequest.dart';
import 'package:pcbuilder.api/transport/searchqueryaddrequest.dart';
import 'package:pcbuilder.api/transport/searchqueryresponse.dart';

/// Get [Backend] instance singleton.

Backend backend = new Backend();

/// Backend communicatie controller.

class Backend {
  StreamController _errorController = new StreamController.broadcast();

  /// Get the error event stream.
  ///
  /// Will delegate communication errors.

  Stream get onError => _errorController.stream;

  /// Get matchig components.
  ///
  /// Get components filtered by [filter].

  Future<GetMatchingComponentsResponse> getMatchingComponents(
      ComponentMatchingSearch filter) async {

    String data = toJson(filter);

    HttpRequest request;

    try {

      request = await HttpRequest.request(
          (config["backend-server"] ?? "/backend/") +
              "componentitem/getmatchingcomponents",
          method: "POST",
          sendData: data,
          requestHeaders: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          });

    } catch (e) {
      _errorController.add("Failed to get components. Server communication error.");
      return new GetMatchingComponentsResponse();
    }

    if (request.status != 200) {
      _errorController.add("Failed to get components. Internal server error.");
      return new GetMatchingComponentsResponse();
    }

    return fromJson(request.responseText, new GetMatchingComponentsResponse());
  }

  /// Get products
  ///
  /// Get products filtered by [filter].

  Future<ProductsResponse> getProducts(ProductSearch filter) async {

    String data = toJson(filter);

    HttpRequest request;

    try {
      request = await HttpRequest.request(
          (config["backend-server"] ?? "/backend/") +
              "product/getmatching",
          method: "POST",
          sendData: data,
          requestHeaders: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          });
    } catch (e) {
      _errorController.add("Failed to get products. Server communication error.");
      return new ProductsResponse();
    }

    if (request.status != 200) {
      _errorController.add("Failed to get products. Internal server error.");
      return new ProductsResponse();
    }

    ProductsResponse responds =
        fromJson(request.responseText, new ProductsResponse());

    return responds;
  }

  /// Get price history
  ///
  /// Get price history per [priceHistoryRequest].


  Future<PriceHistoryResponse> getPriceHistory(PriceHistoryRequest priceHistoryRequest) async {

    String data = toJson(priceHistoryRequest);

    HttpRequest request;

    try {

      request = await HttpRequest.request(
          (config["backend-server"] ?? "/backend/") +
              "/component/pricehistory",
          method: "POST",
          sendData: data,
          requestHeaders: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          });
    } catch (e) {
      _errorController.add("Failed to get price history. Server communication error.");
      return null;
    }

    if (request.status != 200) {
      _errorController.add("Failed to get price history. Internal server error.");
      return new PriceHistoryResponse();
    }

    return fromJson(request.responseText, new PriceHistoryResponse());
  }

  /// Get crawlers
  ///
  /// Get all crawlers.

  Future<CrawlerResponse> getCrawlers() async {

    HttpRequest request;

    try {
      request = await HttpRequest.request(
          (config["backend-server"] ?? "/backend/") +
              "crawler/getall",
          method: "GET",
          requestHeaders: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          });
    } catch (e) {
      _errorController.add("Failed to get crawlers. Server communication error.");
      return null;
    }

    if (request.status != 200) {
      _errorController.add("Failed to get crawlers. Internal server error.");
      return new CrawlerResponse();
    }

    return fromJson(request.responseText, new CrawlerResponse());
  }

  /// Update crawler
  ///
  /// Update the given [crawler].

  Future updateCrawler(Crawler crawler) async {

    String data = toJson(crawler);

    try {
      return await HttpRequest.request(
          (config["backend-server"] ?? "/backend/") +
              "crawler/update",
          method: "POST",
          sendData: data,
          requestHeaders: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          });

    } catch (e) {
      _errorController.add("Failed to update crawler. Server communication error.");
    }

    return "";
  }

  /// Get search queries
  ///
  /// Get search queries per [searchQueryRequest].

  Future<SearchQueryResponse> getSearches(
       SearchQueryRequest searchQueryRequest) async {

    String data = toJson(searchQueryRequest);

    HttpRequest request;

    try {
      request = await HttpRequest.request(
          (config["backend-server"] ?? "/backend/") +
              "searches/get",
          method: "POST",
          sendData: data,
          requestHeaders: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          });
    } catch (e) {
      _errorController.add("Failed to get searches. Server communication error.");
      return new SearchQueryResponse();
    }

    if (request.status != 200) {
      _errorController.add("Failed to get searches. Internal server error.");
      return new SearchQueryResponse();
    }

    SearchQueryResponse responds =
    fromJson(request.responseText, new SearchQueryResponse());

    return responds;
  }

  /// Post search query.
  ///
  /// Add a search query to the backend per [searchQueryAddRequest].

  void postSearchQuery(SearchQueryAddRequest searchQueryAddRequest) {

    String data = toJson(searchQueryAddRequest);

    try {
      HttpRequest.request(
          (config["backend-server"] ?? "/backend/") +
              "searches/add",
          method: "POST",
          sendData: data,
          requestHeaders: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          });
    } catch (e) {
      _errorController.add("Failed to post search request. Server communication error.");
    }
  }
}