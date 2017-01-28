import 'package:dartson/dartson.dart';

@Entity()
class PriceHistoryRequest {
  int componentId;
  DateTime fromDate;
  DateTime toDate;
  bool min;
}