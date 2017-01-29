import 'package:yaml/yaml.dart';

/// Get the configuration instance.
final Config config = new Config();

/// Config contains the current configuration as provided by the loaded source.
class Config {
  YamlMap _yaml;

  /// Init config.
  ///
  /// Parse [cfgSource] as a YAML string and sets it as the current
  /// configuration source.

  void init(String cfgSource) {
    _yaml = loadYaml(cfgSource);
  }

  /// Contains setting.
  ///
  /// Returns true when the setting [key] exists in the configuration.

  bool contains(String key) => _yaml.containsKey(key);

  /// Get setting.
  ///
  /// Get the setting named [key].

  dynamic operator [](String key) => _yaml != null ? _yaml[key] : null;
}
