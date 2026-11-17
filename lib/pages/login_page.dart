import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import 'main_page.dart';

// GANTI dengan NIM kamu.
const kNim = '124240092';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _user = TextEditingController();
  final _pass = TextEditingController();

  Future<void> _login() async {
    if (_user.text == kNim && _pass.text == '123') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _user.text);
      NotificationService.show('Login berhasil', 'Selamat datang di NontonSkuy!');
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainPage()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Username atau password salah')));
    }
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
        hintText: label,
        prefixIcon: Icon(icon),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey)),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              const Icon(Icons.movie, size: 90, color: Colors.red),
              const SizedBox(height: 8),
              const Text('NontonSkuy!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              TextField(controller: _user, decoration: _dec('Username', Icons.person)),
              const SizedBox(height: 16),
              TextField(
                  controller: _pass, obscureText: true, decoration: _dec('Password', Icons.lock)),
              const SizedBox(height: 16),
              FilledButton(onPressed: _login, child: const Text('Login')),
            ]),
          ),
        ),
      );
}
