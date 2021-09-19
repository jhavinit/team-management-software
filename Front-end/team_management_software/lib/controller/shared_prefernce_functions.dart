import 'package:shared_preferences/shared_preferences.dart';

var sharedPreferenceLoginKey="LoginKey";

class SharedPreferencesFunctions {
  static Future getIsUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceLoginKey);
  }

  static Future<void> setIsUserLoggedIn(bool b) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("setting shared pref to true success");
    await preferences.setBool(sharedPreferenceLoginKey, b);
  }

}