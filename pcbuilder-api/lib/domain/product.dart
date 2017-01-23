library PCBuilder.Product;

import 'component.dart';
import 'shop.dart';
import 'package:dartson/dartson.dart';

@Entity()
class Product {
  int id;
  Component component;
  Shop shop;
  double currentPrice;
  String productUrl;
}
