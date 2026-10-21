import 'package:flutter/material.dart';

enum WorkoutCategory {
  strength('Strength', Icons.fitness_center),
  cardio('Cardio', Icons.directions_run),
  hiit('HIIT', Icons.timer),
  yoga('Yoga', Icons.self_improvement),
  crossfit('CrossFit', Icons.sports_gymnastics);

  final String label;
  final IconData icon;

  const WorkoutCategory(this.label, this.icon);

  // R2: Exhaustive switch expression returning a ColorScheme role
  Color getColor(ColorScheme colorScheme) {
    return switch (this) {
      WorkoutCategory.strength => colorScheme.primary,
      WorkoutCategory.cardio => colorScheme.secondary,
      WorkoutCategory.hiit => colorScheme.tertiary,
      WorkoutCategory.yoga => colorScheme.error,
      WorkoutCategory.crossfit => colorScheme.outline,
    };
  }
}
