import 'package:dartson/type_transformer.dart';

class SearchQueryTypeTransformer<T> extends TypeTransformer {
  SearchQueryType decode(dynamic value) => new _SearchQueryType(value);
  dynamic encode(T value) => (value as SearchQueryType).toString();
}


abstract class SearchQueryType {
  static final SearchQueryType FILTER = new _SearchQueryType("FILTER");
  static final SearchQueryType SELECTION = new _SearchQueryType("SELECTION");
  operator ==(SearchQueryType other);
  String toString();
}

class _SearchQueryType implements SearchQueryType {
  String _val;
  _SearchQueryType(this._val) {}
  operator ==(SearchQueryType other) => _val == (other as _SearchQueryType)._val;
  String toString() => _val;
}