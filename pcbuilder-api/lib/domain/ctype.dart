import 'package:dartson/type_transformer.dart';

class CTypeTransformer<T> extends TypeTransformer {
  CType decode(dynamic value) => new _CType(value);
  dynamic encode(T value) => (value as CType).toString();
}

abstract class CType {
  static final CType MOTHERBOARD = new _CType("MOTHERBOARD");
  static final CType CPU = new _CType("CPU");
  static final CType GPU = new _CType("GPU");
  static final CType MEMORY = new _CType("MEMORY");
  static final CType STORAGE = new _CType("STORAGE");
  static final CType PSU = new _CType("PSU");
  static final CType CASE = new _CType("CASE");
  operator ==(CType other);
  String toString();
}

class _CType implements CType {
  String _val;
  _CType(this._val) {}
  operator ==(CType other) => _val == (other as _CType)._val;
  String toString() => _val;
}