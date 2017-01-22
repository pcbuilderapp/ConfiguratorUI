class Connector {
  String name;
  String type;

  Map toJson() => {"name": name, "type": type};
}
