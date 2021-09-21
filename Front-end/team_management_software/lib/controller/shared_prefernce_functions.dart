import 'package:shared_preferences/shared_preferences.dart';

var sharedPreferenceLoginKey="LoginKey";
var  sharedPrefUserNameKey="userNameKey";

class SharedPreferencesFunctions {
  static Future getIsUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceLoginKey);
  }

  static Future<void> setIsUserLoggedIn(bool b) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("setting shared pref to $b success");
    await preferences.setBool(sharedPreferenceLoginKey, b);
  }

  static Future getUserName() async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    return preferences.getString(sharedPrefUserNameKey);
  }
  static Future<void> saveUserName(String username) async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    await preferences.setString(sharedPrefUserNameKey, username);
  }


}