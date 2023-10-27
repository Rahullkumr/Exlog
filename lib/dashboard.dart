import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final String email;
  final String password;
  const DashboardPage({super.key, required this.email, required this.password });

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Dashboard'),
          centerTitle: true,
        ),
        body: Center(
          child: Text(email),
        ),
      ),
    );
  }
}