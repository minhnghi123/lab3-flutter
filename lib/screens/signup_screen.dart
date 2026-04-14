import 'package:flutter/material.dart';
import 'package:test_1/services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Create Account",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              
              // Full Name Field
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your name';
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Email Field
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'The field cannot be empty';
                  final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                  if (!emailRegex.hasMatch(value)) return 'Invalid email address';
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Password Field
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'The field cannot be empty';
                  if (value.length < 7) return 'The password must contain at least 7 characters';
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Confirm Password Field
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_reset),
                ),
                validator: (value) {
                  if (value != passwordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Sign Up Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Gọi API đăng ký
                    await api.send("signup", {
                      "name": nameController.text,
                      "email": emailController.text,
                      "password": passwordController.text
                    });

                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Success'),
                          content: const Text('Account created successfully!'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            )
                          ],
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: const Text('Register Now'),
              ),

              // Back to Login
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Already have an account? Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
