
import 'componentitem.dart';

class Configuration {
  ComponentItem motherboard;
  ComponentItem cpu;
  ComponentItem gpu;
  ComponentItem memory;
  ComponentItem storage;
  ComponentItem psu;
  ComponentItem casing;

  double priceTotal() {
    double total = 0.0;
    total += motherboard != null ? motherboard.price : 0.0;
    total += cpu != null ? cpu.price : 0.0;
    total += gpu != null ? gpu.price : 0.0;
    total += memory != null ? memory.price : 0.0;
    total += storage != null ? storage.price : 0.0;
    total += psu != null ? psu.price : 0.0;
    total += casing != null ? casing.price : 0.0;
    return total;
  }

  Map toJson() => {
    "motherboard":motherboard,
    "cpu":cpu,
    "gpu": gpu,
    "memory": memory,
    "storage":storage,
    "psu":psu,
    "casing": casing
  };
}