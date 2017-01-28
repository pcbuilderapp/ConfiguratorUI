import 'package:dartson/dartson.dart';
import '../domain/searchquerytype.dart';
import 'componentref.dart';

@Entity()
class SearchQueryAddRequest {
  String filter;
  SearchQueryType type;
  ComponentRef component;
}
