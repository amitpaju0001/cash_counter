import 'package:cash_counter/dashboard/ui/dashboard_screen.dart';
import 'package:cash_counter/login/model/user_model.dart';
import 'package:cash_counter/login/provider/auth_provider.dart';
import 'package:cash_counter/login/ui/register_screen.dart';
import 'package:cash_counter/shared/app_colors.dart';
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
        appBar: AppBar(),
        body: Consumer<AuthProvider>(
          builder: (context, authProvider, widget) {
            return Center(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      children:[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              login,
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              loginText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Text(
                              email,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            AppTextField(
                              controller: emailController,
                              hintText: emailFieldHint,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Text(
                              password,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            AppTextField(
                              controller: passwordController,
                              obscureText: authProvider.isVisible ? false : true,
                              hintText: passwordFieldHint,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                onPressed: () {
                                  authProvider.setPasswordFieldStatus();
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            InkWell(
                              onTap: () {
                                loginUser();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: buttonBackground,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Text(
                                  login,
                                  style: TextStyle(color: buttonTextColor),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(noAccount),
                                const SizedBox(
                                  width: 4,
                                ),
                                TextButton(
                                    onPressed: () {
                                      openRegisterUser();
                                    },
                                    child: const Text(
                                      register,
                                      style: TextStyle(color: textButtonColor),
                                    ))
                              ],
                            )
                          ],
                        ),
                      Positioned(child: authProvider.isLoading?CircularProgressIndicator():SizedBox()),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  void openRegisterUser() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const RegisterScreen();
      },
    ));
  }

  void loginUser() async{
    UserModel user = UserModel(
        email: emailController.text, password: passwordController.text);
    AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);
   bool isExist = await authProvider.isUserExists(user);
   if(isExist&& mounted){
     Navigator.push(context, MaterialPageRoute(builder: (context) {
       return DashboardScreen();
     },));
   }
  }
}
