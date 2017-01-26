import 'package:dartson/type_transformer.dart';

class SearchQueryTypeTransformer<T> extends TypeTransformer {
  SearchQueryType decode(dynamic value) {
    String str = value;
    if (str.toUpperCase() == "SELECTION") return SearchQueryType.SELECTION;
    return SearchQueryType.FILTER;
  }

  dynamic encode(T value) {
    return searchQueryType(value);
  }
}

enum SearchQueryType {
  FILTER, SELECTION
}

String searchQueryType(SearchQueryType type) {
  if (type == SearchQueryType.SELECTION) return "SELECTION";
  return "FILTER";
}