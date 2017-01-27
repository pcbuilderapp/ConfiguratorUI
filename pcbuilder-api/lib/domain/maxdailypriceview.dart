library PCBuilder.MinDailyPriceView;

import 'package:dartson/dartson.dart';

@Entity()
class DailyPriceView {
  int pricepoint_id;
  int componentId;
  int date;
  double price;
}
