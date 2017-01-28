import 'package:dartson/type_transformer.dart';

class DateTimeTransformer<T> extends TypeTransformer {
  DateTime decode(dynamic value) => new DateTime.fromMillisecondsSinceEpoch(value);
  dynamic encode(T value) => (value as DateTime).millisecondsSinceEpoch;
}