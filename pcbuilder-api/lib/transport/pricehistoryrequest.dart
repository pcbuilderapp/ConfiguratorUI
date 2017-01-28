import 'package:dartson/dartson.dart';

@Entity()
class PriceHistoryRequest {
  int componentId;
  int fromDate;
  int toDate;
  bool min;
}