import 'dart:async';
import 'dart:html';
import 'transport/componentitem.dart';
import 'domain/connector.dart';
import 'transport/componentmatchingsearch.dart';
import 'transport/alternativeshopitem.dart';
import 'transport/matchingcomponentsresponse.dart';
import 'transport/productsresponse.dart';
import 'transport/productsearch.dart';
import 'domain/product.dart';
import 'config.dart';
import 'serializer.dart';
import 'package:pcbuilder.api/transport/pricepointresponse.dart';

Backend backend = new Backend();

class Backend {

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
      print(e);
      return new GetMatchingComponentsResponse();
    }
    GetMatchingComponentsResponse responds =
        fromJson(request.responseText, new GetMatchingComponentsResponse());

    return responds;
  }

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
      print(e);
      return new ProductsResponse();
    }

    ProductsResponse responds =
        fromJson(request.responseText, new ProductsResponse());

    return responds;
  }

  Future<PricePointResponse> getPriceHistory(int productId) async {

    HttpRequest request;

    try {
      request = await HttpRequest.request(
          (config["backend-server"] ?? "/backend/") +
              "product/getpricehistory?id="+productId.toString(),
          method: "GET",
          requestHeaders: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          });
    } catch (e) {
      print(e);
      return null;
    }

    return fromJson(request.responseText, new PricePointResponse());
  }
}
