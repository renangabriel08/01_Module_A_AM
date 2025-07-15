import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moduloa1/pages/game.dart';
import 'package:moduloa1/pages/home.dart';
import 'package:moduloa1/pages/score.dart';
import 'package:moduloa1/pages/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routes: {
        '/home': (context) => const Home(),
        '/scores': (context) => const Score(),
        '/settings': (context) => const Settings(),
        '/game': (context) => const Game(),
      },
      initialRoute: '/home',
    );
  }
}
