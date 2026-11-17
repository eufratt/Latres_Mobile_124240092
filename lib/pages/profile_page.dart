import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Profil'), centerTitle: true),
        body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snap) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const CircleAvatar(
                  radius: 68,
                  backgroundColor: Color(0xFF444444),
                  child: Icon(Icons.person, size: 70, color: Colors.white70)),
              const SizedBox(height: 24),
              Text(snap.data?.getString('username') ?? '-',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              // GANTI dengan kesan & pesan kamu.
              const Text(
                'Kesan: Praktikum mobile seru dan banyak ilmu baru.\n'
                'Pesan: Terima kasih kepada para asisten atas bimbingannya!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: () => _logout(context), child: const Text('Logout')),
            ]),
          ),
        ),
      );
}
