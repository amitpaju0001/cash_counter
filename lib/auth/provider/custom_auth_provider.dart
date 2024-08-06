import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cash_counter/auth/model/user_model.dart';
import 'package:cash_counter/auth/service/auth_service.dart';
import 'package:cash_counter/core/storage_helper.dart';

class CustomAuthProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isError = false;
  bool isLoggedIn = false;
  bool isPasswordVisible = false;
  String? _verificationId;

  String? get verificationId => _verificationId;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<void> createAccount(UserModel userModel) async {
    try {
      isLoading = true;
      notifyListeners();

      AuthService authService = Get.find();
      await authService.createAccount(userModel);

      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'The account already exists for that email.');
      } else {
        Fluttertoast.showToast(msg: 'Auth Error ${e.code}');
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> login(UserModel userModel) async {
    try {
      isError = false;
      isLoading = true;
      notifyListeners();

      AuthService authService = Get.find();
      await authService.login(userModel);

      StorageHelper storageHelper = Get.find();
      storageHelper.saveLoginStatus();

      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Wrong password provided for that user.');
      } else {
        Fluttertoast.showToast(msg: 'Auth Error ${e.code}');
      }
    }
  }

  Future<void> logout() async {
    try {
      isError = false;
      isLoading = true;
      notifyListeners();

      AuthService authService = Get.find();
      await authService.logout();

      StorageHelper storageHelper = Get.find();
      storageHelper.removeLoginStatus();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> googleLogin() async {
    try {
      isError = false;
      isLoading = true;
      notifyListeners();

      AuthService authService = Get.find();
      await authService.googleLogin();

      StorageHelper storageHelper = Get.find();
      storageHelper.saveLoginStatus();

      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: 'Google sign-in successful.');
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: 'Google sign-in failed: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      isError = false;
      isLoading = true;
      notifyListeners();

      AuthService authService = Get.find();
      await authService.resetPassword(email);

      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: 'Password reset link sent.');
    } on FirebaseAuthException catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: 'Auth Error ${e.code}');
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();

      FirebaseAuth _auth = FirebaseAuth.instance;

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Handle auto sign-in on Android
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading = false;
          isError = true;
          notifyListeners();
          Fluttertoast.showToast(msg: 'Phone Auth Error: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          isLoading = false;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      isLoading = false;
      isError = true;
      notifyListeners();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> signInWithOtp(String verificationId, String otp) async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();

      FirebaseAuth _auth = FirebaseAuth.instance;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      isError = true;
      notifyListeners();
      Fluttertoast.showToast(msg: 'Invalid OTP');
    }
  }

  Future<void> loadLoginStatus() async {
    StorageHelper storageHelper = Get.find();
    isLoggedIn = await storageHelper.getLoginStatus();
    notifyListeners();
  }
}
