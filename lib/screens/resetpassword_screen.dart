import 'package:flutter/material.dart';
import 'package:test_1/services/api_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Icon(
                Icons.lock_reset_rounded,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                "Forgot Your Password?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your email address below and we'll send you a link to reset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              
              // Email Field
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'The field cannot be empty';
                  final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                  if (!emailRegex.hasMatch(value)) return 'Invalid email address';
                  return null;
                },
              ),
              const SizedBox(height: 25),

              // Reset Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Gọi API yêu cầu reset mật khẩu
                    await api.send("reset-password", {
                      "email": emailController.text,
                    });

                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Check Your Email'),
                          content: const Text('We have sent a password reset link to your email.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Đóng Dialog
                                Navigator.pop(context); // Quay lại màn hình Login
                              },
                              child: const Text('Back to Login'),
                            )
                          ],
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                child: const Text('Send Reset Link'),
              ),
              
              const SizedBox(height: 10),
              
              // Back to Login
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Wait, I remember my password!"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
