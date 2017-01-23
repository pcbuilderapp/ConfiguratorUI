import 'componentitem.dart';
import 'package:dartson/dartson.dart';

@Entity()
class GetMatchingComponentsResponse {
  List<ComponentItem> components = [];
  int pageCount;
  int page;
}
