import 'package:shared_preferences/shared_preferences.dart';

class LocalStrage {
  static final LocalStrage _instance = LocalStrage._internal();

  factory LocalStrage() {
    return _instance;
  }

  LocalStrage._internal() {
    SharedPreferences.getInstance().then((value) => prefs = value);
    print("aaasdcsdc");
  }

  SharedPreferences? prefs;
}
