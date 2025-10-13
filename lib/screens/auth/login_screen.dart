import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController empIdCtrl = TextEditingController();
  final TextEditingController pinCtrl = TextEditingController();

  void _login() {
    if (empIdCtrl.text == "1234" && pinCtrl.text == "0000") {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid credentials")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Login', style: TextStyle(fontSize: 28)),
              const SizedBox(height: 24),
              TextField(
                controller: empIdCtrl,
                decoration: const InputDecoration(labelText: 'Employee ID'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: pinCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'PIN'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _login, child: const Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
