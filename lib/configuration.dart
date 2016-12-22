
import 'component.dart';

class Configuration {
  Component motherboard;
  Component cpu;
  Component gpu;
  Component memory;
  Component storage;
  Component psu;
  Component casing;

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