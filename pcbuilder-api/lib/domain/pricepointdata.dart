library PCBuilder.MinDailyPriceView;

import 'package:dartson/dartson.dart';

@Entity()
class PricePointData {
  int date;
  double price;
}