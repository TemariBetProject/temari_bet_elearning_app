import 'package:flutter/material.dart';
import 'package:temari_bet_elearning_app/screens/authentication/login_screen.dart';
import 'package:temari_bet_elearning_app/screens/authentication/registration_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:temari_bet_elearning_app/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString('token')));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({
    @required this.token,
    super.key,
  });

  String _getInitialRoute(String? token) {
    if (token != null && !JwtDecoder.isExpired(token)) {
      return '/register'; // Navigate to registration screen if token is valid
    } else {
      return '/login'; // Navigate to login screen if token is expired or not present
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temari Bet E-learning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => HomeScreen(),
        '/register': (context) => const RegistrationScreen(),
      },
    );
  }
}
