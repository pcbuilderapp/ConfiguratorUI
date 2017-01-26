import 'package:dartson/dartson.dart';

@Entity()
class SearchQueryRequest {
  String filter;
  int page;
  int maxItems;
  String sort;
}
