import 'package:flutter/material.dart';
import '../screens/trigger_screen.dart'; // Startseite
import '../screens/symptom_screen.dart';
import '../screens/overview_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => TriggerScreen(),
      '/symptoms': (context) => SymptomScreen(),
      '/overview': (context) => OverviewScreen(),
    },
  ));
}
