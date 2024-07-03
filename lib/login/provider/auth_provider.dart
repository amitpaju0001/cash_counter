
import 'package:cash_counter/login/model/user_model.dart';
import 'package:cash_counter/login/service/database_service.dart';
import 'package:cash_counter/shared/app_util.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier{
  DatabaseService databaseService;
  AuthProvider(this.databaseService);
bool isVisible = false;
bool isLoading = false;
String? error;
void setPasswordFieldStatus(){
  isVisible = !isVisible;
  notifyListeners();
}
Future registerUser( UserModel user) async{
  isLoading = true;
  error = null;
  notifyListeners();
  await Future.delayed(const Duration(seconds: 3));
  try {

    await databaseService.registerUser(user);

  }catch (e){
    error = e.toString();
    AppUtil.showToast(error!);
  }
  isLoading = false;
  notifyListeners();
}
Future<bool> isUserExists(UserModel user)async{
  try {
    isLoading = true;
    error = null;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 3));
    return await databaseService.isUserExists(user);
  }catch(e){
    error = e.toString();
    AppUtil.showToast(error!);
  }
  finally{
    isLoading = false;
    notifyListeners();
  }
  return false;
}
}