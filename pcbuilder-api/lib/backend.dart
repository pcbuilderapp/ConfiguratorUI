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
import 'package:dartson/dartson.dart';

Backend backend = new Backend();

class Backend {
  Future<GetMatchingComponentsResponse> getMatchingComponents(
      ComponentMatchingSearch filter) async {
    var dson = new Dartson.JSON();
    String data = dson.encode(filter);

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
        dson.decode(request.responseText, new GetMatchingComponentsResponse());

    return responds;
  }

  Future<ProductsResponse> getProducts(ProductSearch filter) async {
    var dson = new Dartson.JSON();
    String data = dson.encode(filter);

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
      return new ProductsResponse();
    }

    ProductsResponse responds =
        dson.decode(request.responseText, new ProductsResponse());

    return responds;
  }
}
