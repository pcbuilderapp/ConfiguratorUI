library PCBuilder.Serializer;
import 'package:dartson/dartson.dart';
import 'domain/ctype.dart';
import 'domain/searchquerytype.dart';
import 'transformers/datetime.dart';

Dartson _dson = _initSerializer();

Dartson _initSerializer() {
  var dson = new Dartson.JSON();
  dson.addTransformer(new CTypeTransformer(), CType);
  dson.addTransformer(new SearchQueryTypeTransformer(), SearchQueryType);
  dson.addTransformer(new DateTimeTransformer(), DateTime);
  return dson;
}

/// Convert a serializable object to JSON.

String toJson(dynamic object) {
  return _dson.encode(object);
}

/// Convert a JSON string to an object.
///
/// [target] is the root object instance for the JSON stream.

dynamic fromJson(String json, Object target) {
  return _dson.decode(json,target);
}