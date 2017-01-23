library PCBuilder.Serializer;
import 'package:dartson/dartson.dart';
import 'domain/ctype.dart';

Dartson _dson = _initSerializer();

Dartson _initSerializer() {
  var dson = new Dartson.JSON();
  dson.addTransformer(new CTypeTransformer(), CType);
  return dson;
}

String toJson(dynamic object) {
  _dson.encode(object);
}

dynamic fromJson(String json, Object target) {
  return _dson.decode(json,target);
}