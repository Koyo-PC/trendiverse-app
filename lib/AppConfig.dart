import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  AppConfig._internal();

  factory AppConfig() {
    return _instance;
  }

  final Map<String, dynamic> defaultConfig = {
    "server_ip": "138.2.55.39",
    "server_port": 8080,
  };
  final FutureProvider<SharedPreferences> configProvider = FutureProvider(
    (ref) async => AppConfig().getConfig(),
  );

  Future<SharedPreferences> getConfig() async {
    final pref = await SharedPreferences.getInstance();
    AppConfig().defaultConfig.forEach(
      (key, value) {
        if (pref.containsKey(key)) return;
        if (value is int) {
          pref.setInt(key, value);
        } else if (value is double) {
          pref.setDouble(key, value);
        } else if (value is bool) {
          pref.setBool(key, value);
        } else {
          pref.setString(key, value.toString());
        }
      },
    );
    return pref;
  }
}
