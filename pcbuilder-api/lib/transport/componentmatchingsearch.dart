import 'configuration.dart';
import 'package:dartson/dartson.dart';

@Entity()
class ComponentMatchingSearch {
  String filter;
  String type;
  Configuration configuration;
  int page;
  int maxItems;
  String sort;
}
