import 'package:cash_counter/login/model/user_model.dart';
import 'package:cash_counter/login/provider/auth_provider.dart';
import 'package:cash_counter/login/ui/login_screen.dart';
import 'package:cash_counter/shared/app_colors.dart';
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
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Enter Your Personal Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          userName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: userNameController,
                          hintText: nameFieldHint,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          email,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: emailController,
                          hintText: emailFieldHint,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          password,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: passwordController,
                          obscureText: !authProvider.isVisible,
                          hintText: passwordFieldHint,
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
                        const Text(
                          confirmPassword,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: confirmPasswordController,
                          obscureText: !authProvider.isVisible,
                          hintText: 'Enter Confirm Password',
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
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Text(
                              register,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(alreadyAccount),
                            const SizedBox(
                              width: 4,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
                                },
                                child: const Text(
                                  login,
                                  style: TextStyle(color: textButtonColor),
                                ))
                          ],
                        )
                      ],
                    ),
                    authProvider.isLoading?const CircularProgressIndicator():const SizedBox(),
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
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }));
  }
}
