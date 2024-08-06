import 'package:cash_counter/auth/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<void> createAccount(UserModel userModel) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: userModel.email,
      password: userModel.password,
    );
    print('account created');
  }

  Future<void> login(UserModel userModel) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: userModel.email,
      password: userModel.password,
    );
    print('Login Successfully');
  }

  Future<UserCredential> googleLogin() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      var result = await googleSignIn.signIn();
      if (result == null) {
        throw Exception('Google sign-in aborted');
      }

      final userData = await result.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: userData.accessToken,
        idToken: userData.idToken,
      );

      var finalResult = await FirebaseAuth.instance.signInWithCredential(credential);
      return finalResult;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber,
      Function(String) codeSent,
      Function(FirebaseAuthException) verificationFailed,
      ) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: verificationFailed,
      codeSent: (String verificationId, int? resendToken) {
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> signInWithOtp(String verificationId, String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
