import 'configuration.dart';
import '../domain/ctype.dart';
import 'package:dartson/dartson.dart';

@Entity()
class ComponentMatchingSearch {
  String filter;
  CType type;
  Configuration configuration;
  int page;
  int maxItems;
  String sort;
}
