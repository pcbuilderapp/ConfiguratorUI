import 'package:dartson/dartson.dart';

@Entity()
class ProductSearch {
  String filter;
  int page;
  int maxItems;
  String sort;
}