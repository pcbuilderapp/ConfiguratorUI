
import 'componentitem.dart';

class Configuration {
  ComponentItem motherboard;
  ComponentItem cpu;
  ComponentItem gpu;
  ComponentItem memory;
  ComponentItem storage;
  ComponentItem psu;
  ComponentItem casing;

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