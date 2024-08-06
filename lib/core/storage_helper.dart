import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper{
  final String loginStatusKey = 'loginStatus';
  Future saveLoginStatus()async{
    SharedPreferences sharedPref =await SharedPreferences.getInstance();
    sharedPref.setBool(loginStatusKey, true);
  }
  Future<bool> getLoginStatus()async{
    SharedPreferences sharedPref =await SharedPreferences.getInstance();
    bool? loginStatus =  sharedPref.getBool(loginStatusKey);
    return loginStatus ?? false;

  }
  Future removeLoginStatus()async{
    SharedPreferences sharedPref =await SharedPreferences.getInstance();
    await sharedPref.remove(loginStatusKey);

  }
}