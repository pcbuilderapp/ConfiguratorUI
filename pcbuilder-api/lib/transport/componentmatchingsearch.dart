import 'configuration.dart';
import 'package:dartson/dartson.dart';

@Entity()
class ComponentMatchingSearch {
  String filter;
  String type;
  String sort;
  Configuration configuration;
  int page;
  int maxItems;
}
