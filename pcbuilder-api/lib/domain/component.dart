library PCBuilder.Component;

import 'connector.dart';
import 'ctype.dart';
import 'package:dartson/dartson.dart';

@Entity()
class Component {
  int id;
  String name;
  String brand;
  String europeanArticleNumber;
  String manufacturerPartNumber;
  CType type;
  List<Connector> connectors = [];
  String pictureUrl;
}



