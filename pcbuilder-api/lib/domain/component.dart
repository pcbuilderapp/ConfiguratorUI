library PCBuilder.Component;

import 'connector.dart';
import 'package:dartson/dartson.dart';

@Entity()
class Component {
  int id;
  String name;
  String brand;
  String europeanArticleNumber;
  String manufacturerPartNumber;
  String type;
  List<Connector> connectors = [];
  String pictureUrl;
}



