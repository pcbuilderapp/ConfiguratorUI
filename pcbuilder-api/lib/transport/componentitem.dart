library PCBuilder.ComponentItem;

import 'connector.dart';
import 'alternativeshopitem.dart';
export 'alternativeshopitem.dart';

class ComponentItem {

  int id;
  String name;
  String brand;
  String europeanArticleNumber;
  String manufacturerPartNumber;
  String type;

  String shop;
  double price;
  String url;
  String image;

  List<Connector> connectors = [];
  List<AlternativeShopItem> alternativeShops = [];

  Map toJson() => {
    "id":id
  };
}
