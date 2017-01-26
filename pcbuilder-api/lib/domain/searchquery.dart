library PCBuilder.SearchQuery;

import 'component.dart';
import 'searchquerytype.dart';
import 'package:dartson/dartson.dart';

@Entity()
class SearchQuery {
  int id;
  String filter;
  SearchQueryType type;
  Component component;
  int count;
}
