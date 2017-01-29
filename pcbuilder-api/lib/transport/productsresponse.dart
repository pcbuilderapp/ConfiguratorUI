import 'package:dartson/dartson.dart';
import '../domain/product.dart';

@Entity()
class ProductsResponse {
  List<Product> products=[];
  int page=1;
  int pageCount=0;
}