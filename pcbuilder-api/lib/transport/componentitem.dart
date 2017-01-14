library PCBuilder.ComponentItem;

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

  List<AlternativeShopItem> alternativeShops = [];

  Map toJson() => {
    "id":id
  };
}
