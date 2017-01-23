import 'package:dartson/dartson.dart';
import '../domain/product.dart';

@Entity()
class ProductsResponse {
  List<Product> products;
  int page;
  int pageCount;
}