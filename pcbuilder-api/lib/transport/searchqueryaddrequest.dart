import 'package:dartson/dartson.dart';
import '../domain/searchquerytype.dart';
import '../domain/component.dart';

@Entity()
class SearchQueryAddRequest {
  String filter;
  SearchQueryType type;
  Component component;
}
