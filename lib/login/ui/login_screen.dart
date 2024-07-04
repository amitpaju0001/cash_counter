import 'package:cash_counter/dashboard/ui/dashboard_screen.dart';
import 'package:cash_counter/login/model/user_model.dart';
import 'package:cash_counter/login/provider/auth_provider.dart';
import 'package:cash_counter/login/ui/register_screen.dart';
import 'package:cash_counter/shared/app_string.dart';
import 'package:cash_counter/shared/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, widget) {
          return Center(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            login,
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            loginText,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            email,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
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
                                color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 8),
                          AppTextField(
                            controller: passwordController,
                            obscureText: authProvider.isVisible ? false : true,
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
                          const SizedBox(height: 24),
                          InkWell(
                            onTap: () {
                              loginUser();
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
                                login,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(noAccount),
                              const SizedBox(width: 4),
                              TextButton(
                                onPressed: () {
                                  openRegisterUser();
                                },
                                child: const Text(
                                  register,
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        child: authProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void openRegisterUser() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const RegisterScreen();
      },
    ));
  }

  void loginUser() async {
    UserModel user = UserModel(
        email: emailController.text, password: passwordController.text);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    bool isExist = await authProvider.isUserExists(user);
    if (isExist && mounted) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const DashboardScreen();
        },
      ));
    }
  }
}
