import 'package:yaml/yaml.dart';

final Config config = new Config();

class Config {
  YamlMap _yaml;

  void init(String cfgSource) {
    _yaml = loadYaml(cfgSource);
  }

  dynamic value(String key, dynamic defaultValue) {
    if (!_yaml.containsKey(key)) return defaultValue;
    return _yaml[key];
  }
}