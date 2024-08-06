import 'package:cash_counter/auth/provider/custom_auth_provider.dart';
import 'package:cash_counter/auth/ui/login_screen.dart';
import 'package:cash_counter/auth/ui/otp_screen.dart';
import 'package:cash_counter/shared/app_string.dart';
import 'package:cash_counter/shared/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<CustomAuthProvider>(
              builder: (context, authProvider, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          register,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          createAccount,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: userNameController,
                          hintText: nameFieldHint,
                          fillColor: Colors.grey[100],
                          filled: true,
                          borderRadius: 12,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: emailController,
                          hintText: emailFieldHint,
                          fillColor: Colors.grey[100],
                          filled: true,
                          borderRadius: 12,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          phone,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: phoneController,
                          hintText: phoneNumberFieldHint,
                          fillColor: Colors.grey[100],
                          filled: true,
                          borderRadius: 12,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          password,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: passwordController,
                          obscureText: !authProvider.isPasswordVisible,
                          hintText: passwordFieldHint,
                          fillColor: Colors.grey[100],
                          filled: true,
                          borderRadius: 12,
                          suffixIcon: IconButton(
                            icon: Icon(authProvider.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              authProvider.togglePasswordVisibility();
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          confirmPassword,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: confirmPasswordController,
                          obscureText: !authProvider.isPasswordVisible,
                          hintText: confirmPassword,
                          fillColor: Colors.grey[100],
                          filled: true,
                          borderRadius: 12,
                          suffixIcon: IconButton(
                            icon: Icon(authProvider.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              authProvider.togglePasswordVisibility();
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: () async {
                            if (passwordController.text !=
                                confirmPasswordController.text) {
                              Fluttertoast.showToast(
                                  msg: 'Passwords do not match');
                            } else {
                              print('Verifying phone number...');
                              await authProvider.verifyPhoneNumber(
                                  phoneController.text.toString());
                              print('Verification ID: ${authProvider.verificationId}');
                              if (authProvider.verificationId != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OtpScreen(
                                      verificationId:
                                      authProvider.verificationId!,
                                    ),
                                  ),
                                );
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Failed to verify phone number');
                              }
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.lightBlueAccent
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Text(
                              register,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(alreadyAccount),
                            const SizedBox(width: 4),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                login,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    authProvider.isLoading
                        ? const CircularProgressIndicator()
                        : const SizedBox(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
