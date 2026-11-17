import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'services/favorite_service.dart';

const kRed = Color(0xFFF44336);
const kCard = Color(0xFF2C2C2C);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FavoriteService.init();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(loggedIn: prefs.getString('username') != null));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'NontonSkuy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(primary: kRed),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black, elevation: 0, scrolledUnderElevation: 0),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF0A0A0A),
            selectedItemColor: kRed,
            unselectedItemColor: Colors.white70,
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: kRed,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              shape: const StadiumBorder(),
            ),
          ),
        ),
        home: loggedIn ? const MainPage() : const LoginPage(),
      );
}
