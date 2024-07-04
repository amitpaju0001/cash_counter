import 'package:cash_counter/login/model/user_model.dart';
import 'package:cash_counter/login/provider/auth_provider.dart';
import 'package:cash_counter/login/ui/login_screen.dart';
import 'package:cash_counter/shared/app_string.dart';
import 'package:cash_counter/shared/app_text_field.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<AuthProvider>(
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
                          registerSubtitle,
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
                          obscureText: !authProvider.isVisible,
                          hintText: passwordFieldHint,
                          fillColor: Colors.grey[100],
                          filled: true,
                          borderRadius: 12,
                          suffixIcon: IconButton(
                            icon: Icon(authProvider.isVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              authProvider.setPasswordFieldStatus();
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
                          obscureText: !authProvider.isVisible,
                          hintText: confirmPassword,
                          fillColor: Colors.grey[100],
                          filled: true,
                          borderRadius: 12,
                          suffixIcon: IconButton(
                            icon: Icon(authProvider.isVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              authProvider.setPasswordFieldStatus();
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: () {
                            openRegisterUser();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.blueAccent, Colors.lightBlueAccent],
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

  Future openRegisterUser() async {
    UserModel user = UserModel(
      email: emailController.text,
      password: passwordController.text,
      name: userNameController.text,
    );
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    await provider.registerUser(user);
    if (mounted && provider.error == null) {
      Navigator.pop(context);
    }
  }

  void loginUserScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      ),
    );
  }
}
