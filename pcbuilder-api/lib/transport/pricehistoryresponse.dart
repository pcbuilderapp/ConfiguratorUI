import 'package:dartson/dartson.dart';
import '../domain/pricepointdata.dart';

@Entity()
class PriceHistoryResponse {
  List<PricePointData> priceHistory;
  bool priceFalling;
}