import 'package:flutter/material.dart';
import 'package:test_1/screens/resetpassword_screen.dart';
import 'package:test_1/screens/signup_screen.dart';
import 'package:test_1/services/api_service.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key}) ; 
  @override
  State<LoginScreen> createState() =>_LoginScreenState() ; 
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>() ; 
  final emailController = TextEditingController() ;
  final passwordController = TextEditingController() ; 
  final api = ApiService() ; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 40),
              Image.network("https://cdn-icons-png.flaticon.com/512/747/747376.png",
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 20) , 
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty) return 'The field cannot be empty' ; 
                  final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                  if(!emailRegex.hasMatch(value)) return 'Invalid email address' ; 
                  return null ; 
                },
              
              ),
                const SizedBox(height: 10) , 
                TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty) return 'The field cannot be empty' ; 
                  if(value.length < 7) return 'The password must contain at least 7 characters' ; 
                  return null ; 
                },
              
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // 1. Hiển thị loading (tùy chọn)
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                    );

                    try {
                      // 2. Gửi request
                      final response = await api.send("users", {
                        "email": emailController.text,
                        "password": passwordController.text
                      });

                      // Đóng loading
                      if (mounted) Navigator.pop(context);

                      // 3. Xử lý thành công
                      if (mounted) {
                        showDialog(
                          context: context, 
                          builder: (_) => const AlertDialog(
                            title: Text('Success'),
                            content: Text('Authorization successful!'),
                          ),
                        );
                      }
                    } catch (e) {
                      // Đóng loading nếu đang hiện
                      if (mounted) Navigator.pop(context);

                      // 4. Xử lý lỗi (Mất mạng, Server 500, Sai thông tin...)
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text('Sign in'),
              )
              , 

               const SizedBox(height: 10) ,
               OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> const SignupScreen())) ; 
                },
                child: const Text("Sign Up"),
               ) , 
               TextButton(
                 onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> const ResetPasswordScreen())) ; 
                },
                child: const Text("Forgot Password"),
               )
            ],
          ),
        ),
      ),
    ) ; 
  }
}