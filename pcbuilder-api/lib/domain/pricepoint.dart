library PCBuilder.PriceHistory;

import 'package:dartson/dartson.dart';
import 'product.dart';

@Entity()
class PricePoint {
  int id;
  Product product;
  DateTime pricingDate;
  double price;
}