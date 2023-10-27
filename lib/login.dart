import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  final String email;
  final String password;
  const LoginPage({super.key, required this.email, required this.password });
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text(email),
            const SizedBox(height: 8.0),
            Text(password)
          ],
        ),
      ),
    );
  }
}