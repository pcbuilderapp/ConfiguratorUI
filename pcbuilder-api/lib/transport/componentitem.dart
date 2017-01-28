library PCBuilder.ComponentItem;

import '../domain/connector.dart';
import 'alternativeshopitem.dart';
export 'alternativeshopitem.dart';
import 'package:dartson/dartson.dart';

@Entity()
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
  bool discounted;
  bool priceFalling;

  List<Connector> connectors = [];
  List<AlternativeShopItem> alternativeShops = [];
}
