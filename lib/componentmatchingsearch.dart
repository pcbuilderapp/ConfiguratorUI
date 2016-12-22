import 'configuration.dart';

class ComponentMatchingSearch {
  String filter;
  String type;
  Configuration configuration;
  int page;

  Map toJson() => {
    "filter":filter,
    "type":type,
    "configuration": configuration,
    "page": page
  };
}