import 'dart:collection';

import 'workout_category.dart';

// R1: Immutable WorkoutItem model
class WorkoutItem {
  final String id;
  final String title;
  final WorkoutCategory category;
  final DateTime when;
  final int limit;
  final List<String> _names;
  final bool mode; // true = online link, false = physical venue
  final String venue;
  final String? optionalText;
  final bool favourite;

  WorkoutItem({
    required this.id,
    required this.title,
    required this.category,
    required this.when,
    required this.limit,
    required List<String> names,
    required this.mode,
    required this.venue,
    this.optionalText,
    this.favourite = false,
  }) : _names = List.unmodifiable(names);

  // R1: Prevent external mutation of the internal names list
  UnmodifiableListView<String> get names => UnmodifiableListView(_names);

  // R3: Named constructor for default values
  WorkoutItem.empty()
    : id = '',
      title = '',
      category = WorkoutCategory.strength,
      when = DateTime.now().add(const Duration(days: 1)),
      limit = 10,
      _names = const [],
      mode = false,
      venue = '',
      optionalText = null,
      favourite = false;

  // R4: Derived properties as getters
  int get count => _names.length;
  int get freePlaces => limit - count;
  bool get isFull => freePlaces <= 0;
  bool get isPast => when.isBefore(DateTime.now());
  bool containsName(String name) => _names.contains(name);

  // R5: Record getter returning taken and free counts
  ({int taken, int free}) get places => (taken: count, free: freePlaces);

  WorkoutItem copyWith({
    String? id,
    String? title,
    WorkoutCategory? category,
    DateTime? when,
    int? limit,
    List<String>? names,
    bool? mode,
    String? venue,
    String? optionalText,
    bool? favourite,
  }) {
    return WorkoutItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      when: when ?? this.when,
      limit: limit ?? this.limit,
      names: names ?? this._names,
      mode: mode ?? this.mode,
      venue: venue ?? this.venue,
      optionalText: optionalText ?? this.optionalText,
      favourite: favourite ?? this.favourite,
    );
  }
}
