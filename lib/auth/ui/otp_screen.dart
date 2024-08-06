import 'package:cash_counter/auth/provider/custom_auth_provider.dart';
import 'package:cash_counter/dashboard/ui/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<CustomAuthProvider>(
          builder: (context, authProvider, child) {
            return Column(
              children: [
                TextField(
                  controller: otpController,
                  decoration: const InputDecoration(
                    hintText: 'Enter OTP',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await authProvider.signInWithOtp(widget.verificationId, otpController.text.toString());
                    if (!authProvider.isError) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DashboardScreen()),
                      );
                    }
                  },
                  child: const Text('OTP'),
                ),
                if (authProvider.isLoading) CircularProgressIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
