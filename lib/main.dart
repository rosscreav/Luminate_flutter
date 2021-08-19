//Imports
import 'package:flutter/material.dart';
//Importing different screens
import 'home.dart';
import 'timer.dart';
import 'splash.dart';

//Create the App object
void main() => runApp(App());

//App setup
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Setup App properties
      title: 'lily App',
        //Set start screen as flash
        home: LockScreen(),
        //Setup routes for each screen for navigation
        routes: {
          '/timer': (context) => TreatmentTimer(),
          '/splash': (context) => LockScreen(),
          '/home': (context) => Home(),
        }
    );
  }
}



