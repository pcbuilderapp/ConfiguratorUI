import 'package:dartson/dartson.dart';
import '../domain/maxdailypriceview.dart';

@Entity()
class MaxDailyPriceViewResponse {
  List<DailyPriceView> maxDailyPriceViewList;
}