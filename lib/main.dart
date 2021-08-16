import 'package:flutter/material.dart';
import 'home.dart';
import 'timer.dart';
import 'splash.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
        home: splash(),
        routes: {
          '/timer': (context) => treatment_timer(),
          '/splash': (context) => splash(),
          '/home': (context) => Home(),
        }
    );
  }
}



