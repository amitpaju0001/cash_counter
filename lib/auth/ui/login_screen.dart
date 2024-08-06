import 'package:cash_counter/auth/model/user_model.dart';
import 'package:cash_counter/auth/provider/custom_auth_provider.dart';
import 'package:cash_counter/auth/ui/forgot_password_screen.dart';
import 'package:cash_counter/dashboard/ui/dashboard_screen.dart';
import 'package:cash_counter/shared/app_string.dart';
import 'package:cash_counter/shared/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cash_counter/auth/ui/register_screen.dart';

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
      body: Consumer<CustomAuthProvider>(
        builder: (context, authProvider, widget) {
          return Center(
            child: SingleChildScrollView(
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
                          obscureText: authProvider.isPasswordVisible ? false : true,
                          hintText: passwordFieldHint,
                          fillColor: Colors.grey[100],
                          filled: true,
                          borderRadius: 12,
                          suffixIcon: IconButton(
                            icon: Icon(authProvider.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: () {
                            loginUser(authProvider);
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
                        Container(
                          height: 50,
                          child: Center(
                            child: GestureDetector(
                              onTap: () async {
                                CustomAuthProvider provider =
                                Provider.of<CustomAuthProvider>(context, listen: false);
                                await provider.googleLogin();
                                if (!provider.isError) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DashboardScreen(),
                                    ),
                                  );
                                }
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesomeIcons.google,size: 20,),
                                  SizedBox(width: 5),
                                  Text(
                                    'Google Login',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ForgotPasswordScreen();
                                  },
                                ),
                              );
                            },
                            child: const Text('Forgot Password?'),
                          ),
                        ),
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

  void loginUser(CustomAuthProvider authProvider) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    UserModel user = UserModel(
        email: emailController.text, password: passwordController.text);

    try {
      await authProvider.login(user);
      if (authProvider.isLoggedIn) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const DashboardScreen();
          },
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
