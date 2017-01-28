library PCBuilder.MinDailyPriceView;

import 'package:dartson/dartson.dart';

@Entity()
class PricePointData {
  DateTime date;
  double price;
}