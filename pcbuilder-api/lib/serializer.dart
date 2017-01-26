library PCBuilder.Serializer;
import 'package:dartson/dartson.dart';
import 'domain/ctype.dart';
import 'domain/searchquerytype.dart';

Dartson _dson = _initSerializer();

Dartson _initSerializer() {
  var dson = new Dartson.JSON();
  dson.addTransformer(new CTypeTransformer(), CType);
  dson.addTransformer(new SearchQueryTypeTransformer(), SearchQueryType);
  return dson;
}

String toJson(dynamic object) {
  return _dson.encode(object);
}

dynamic fromJson(String json, Object target) {
  return _dson.decode(json,target);
}