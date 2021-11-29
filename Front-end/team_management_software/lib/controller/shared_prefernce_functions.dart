import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_management_software/constants.dart';

var sharedPreferenceLoginKey="LoginKey";
var  sharedPrefUserNameKey="userNameKey";
var  sharedPrefUserDetails="userDetailsKey";
var sharedPrefRole="roleKey";


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

  static Future getRole() async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    return preferences.getString(sharedPrefRole);
  }
  static Future<void> saveRole(String role) async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    await preferences.setString(sharedPrefRole, role);
  }

  static Future<void> saveUserDetails(String userDetails) async{
    print("from shared pref");
    print(userDetails);
    Constants.userDetails=userDetails;

    SharedPreferences preferences= await SharedPreferences.getInstance();
    await preferences.setString(sharedPrefUserDetails, userDetails);
  }
  static Future getUserDetails() async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    return preferences.getString(sharedPrefUserDetails);
  }



}