import 'package:flutter/material.dart';

import 'routes.dart';

void main() {
  runApp(const MyApp());
}

// R11: ThemeMode lives in MyApp's State above MaterialApp
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>()!;
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    // R12: setState wraps state change only
    setState(() {
      _themeMode = mode;
    });
  }

  ThemeMode get themeMode => _themeMode;

  @override
  Widget build(BuildContext context) {
    // R22: ColorScheme.fromSeed for light and dark themes
    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'Workout Tracker',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      initialRoute: Routes.shell,
      onGenerateRoute: Routes.onGenerateRoute,
      onUnknownRoute: Routes.onUnknownRoute,
    );
  }
}
