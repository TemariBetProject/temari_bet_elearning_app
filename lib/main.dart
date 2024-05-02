import 'package:flutter/material.dart';
import 'package:temari_bet_elearning_app/screens/authentication/login_screen.dart';
import 'package:temari_bet_elearning_app/screens/authentication/registration_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:temari_bet_elearning_app/screens/home/home_screen.dart';
import 'package:temari_bet_elearning_app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await NotificationService().init();
  runApp(MyApp(token: prefs.getString('token')));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({required this.token, super.key});

  String _getInitialRoute(String? token) {
    if (token != null && !JwtDecoder.isExpired(token)) {
      return '/home';
    } else {
      return '/login';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temari Bet E-learning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: _getInitialRoute(token),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
