import 'package:dartson/dartson.dart';
import '../domain/pricepoint.dart';

@Entity()
class PricePointResponse {
  List<PricePoint> pricePoints;
}