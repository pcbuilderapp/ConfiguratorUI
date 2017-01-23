import 'package:dartson/type_transformer.dart';

class CTypeTransformer<T> extends TypeTransformer {
  T decode(dynamic value) {
    String str = value;
    if (str.toUpperCase() == "CPU") return CType.CPU;
    if (str.toUpperCase() == "GPU") return CType.GPU;
    if (str.toUpperCase() == "MEMORY") return CType.MEMORY;
    if (str.toUpperCase() == "STORAGE") return CType.STORAGE;
    if (str.toUpperCase() == "PSU") return CType.PSU;
    if (str.toUpperCase() == "CASE") return CType.CASE;
    return CType.MOTHERBOARD;
  }

  dynamic encode(T value) {
    if (value == CType.CPU) return "CPU";
    if (value == CType.GPU) return "GPU";
    if (value == CType.MEMORY) return "MEMORY";
    if (value == CType.STORAGE) return "STORAGE";
    if (value == CType.CASE) return "CASE";
    if (value == CType.PSU) return "PSU";
    return "MOTHERBOARD";
  }
}

enum CType {
  MOTHERBOARD, CPU, GPU, MEMORY, STORAGE, PSU, CASE
}