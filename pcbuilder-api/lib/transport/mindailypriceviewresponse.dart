import 'package:dartson/dartson.dart';
import '../domain/maxdailypriceview.dart';

@Entity()
class MinDailyPriceViewResponse {
  List<DailyPriceView> minDailyPriceViewList;
}