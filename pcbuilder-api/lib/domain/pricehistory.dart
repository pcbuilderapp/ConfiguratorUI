library PCBuilder.PriceHistory;

import 'package:dartson/dartson.dart';

@Entity()
class PriceHistory {
  int year;
  int month;
  int day;
  double price;
}