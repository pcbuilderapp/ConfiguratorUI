import 'configuration.dart';

class ComponentMatchingSearch {
  String filter;
  String type;
  String sort;
  Configuration configuration;
  int page;
  int maxItems;

  Map toJson() => {
        "filter": filter,
        "type": type,
        "configuration": configuration,
        "page": page,
        "maxItems": maxItems,
        "sort": sort
      };
}
