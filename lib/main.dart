import 'package:flutter/material.dart';
import '../screens/trigger_screen.dart';
import '../screens/symptom_screen.dart';
import '../screens/overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleThemeMode() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[100],
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.lightBlue,
          brightness: Brightness.light,
        ).copyWith(
          secondary: Colors.lightGreen[100],
          background: Colors.white,
          surface: Colors.grey[200],
          onPrimary: Colors.black87,
          onSecondary: Colors.black87,
          onBackground: Colors.black87,
          onSurface: Colors.black87,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.lightBlue[100],
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.lightBlue[800],
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreen[300],
            foregroundColor: Colors.black87,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.lightBlue[300],
          inactiveTrackColor: Colors.lightBlue[100],
          thumbColor: Colors.lightBlue[300],
          overlayColor: Colors.lightBlue[100]?.withOpacity(0.2),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[900],
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          brightness: Brightness.dark,
        ).copyWith(
          secondary: Colors.teal[200],
          background: Colors.black,
          surface: Colors.grey[800],
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          color: Colors.blueGrey[900],
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.teal[200],
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[700],
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.teal[700],
          inactiveTrackColor: Colors.teal[200],
          thumbColor: Colors.teal[700],
          overlayColor: Colors.teal[200]?.withOpacity(0.2),
        ),
      ),
      themeMode: _themeMode,
      home: HomeScreen(toggleThemeMode: _toggleThemeMode),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  final VoidCallback toggleThemeMode;

  HomeScreen({required this.toggleThemeMode});

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        TriggerScreen(pageController: _pageController, toggleThemeMode: toggleThemeMode),
        SymptomScreen(pageController: _pageController, toggleThemeMode: toggleThemeMode),
        OverviewScreen(pageController: _pageController, toggleThemeMode: toggleThemeMode),
      ],
    );
  }
}