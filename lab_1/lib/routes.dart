import 'package:flutter/material.dart';

import 'models/workout_item.dart';
import 'screens/shell_screen.dart';
import 'screens/workout_detail_screen.dart';
import 'screens/workout_form_screen.dart';

// R25: Route constants and centralized typed route generator
class Routes {
  static const String shell = '/';
  static const String detail = '/detail';
  static const String form = '/form';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case shell:
        return MaterialPageRoute(
          builder: (_) => const ShellScreen(),
          settings: settings,
        );
      case detail:
        final args = settings.arguments as WorkoutDetailArgs;
        return MaterialPageRoute(
          builder: (_) => WorkoutDetailScreen(args: args),
          settings: settings,
        );
      case form:
        final initialItem = settings.arguments as WorkoutItem?;
        return MaterialPageRoute<WorkoutItem?>(
          builder: (_) => WorkoutFormScreen(initialItem: initialItem),
          settings: settings,
        );
      default:
        return onUnknownRoute(settings);
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(child: Text('Page not found')),
      ),
    );
  }
}
