import '../models/user_profile.dart';
import '../models/workout_category.dart';
import '../models/workout_item.dart';

final UserProfile initialProfile = const UserProfile(
  name: 'Nurzhas Bergenbay',
  group: 'IS-2101',
);

List<WorkoutItem> getInitialSeedItems() {
  final now = DateTime.now();

  return [
    // Requirement Edge Case 1: 60-character title (exactly 60 chars)
    WorkoutItem(
      id: 'w1',
      title: 'Advanced Full Body High Intensity Strength Training Session 2026',
      category: WorkoutCategory.strength,
      when: now.add(const Duration(days: 2, hours: 3)),
      limit: 15,
      names: ['Alex', 'Meyrambek'],
      mode: false,
      venue: 'KBTU Gym Room 1',
      optionalText: 'Bring your own wrist wraps and lifting belt.',
      favourite: true,
    ),

    // Requirement Edge Case 2: Item at its limit (Full)
    WorkoutItem(
      id: 'w2',
      title: 'Core & Endurance Circuit Training',
      category: WorkoutCategory.hiit,
      when: now.add(const Duration(days: 1, hours: 5)),
      limit: 3,
      names: ['John', 'Sarah', 'Nurzhas Bergenbay'],
      mode: false,
      venue: 'Fitness Arena Hall B',
      optionalText: 'High intensity interval session.',
      favourite: false,
    ),

    // Requirement Edge Case 3: Past item
    WorkoutItem(
      id: 'w3',
      title: 'Early Morning Cardio Burnout',
      category: WorkoutCategory.cardio,
      when: now.subtract(const Duration(days: 2, hours: 4)),
      limit: 20,
      names: ['Meyrambek', 'Elena'],
      mode: false,
      venue: 'Central Park Running Track',
      optionalText: 'Completed morning outdoor run.',
      favourite: true,
    ),

    // Requirement Edge Case 4: Item with mode on (Online mode with URL)
    WorkoutItem(
      id: 'w4',
      title: 'Guided Evening Mindfulness Yoga',
      category: WorkoutCategory.yoga,
      when: now.add(const Duration(hours: 12)),
      limit: 50,
      names: ['Anna', 'Dmitry'],
      mode: true,
      venue: 'https://zoom.us/j/workout987654321',
      optionalText: 'Online stream session for relaxation.',
      favourite: false,
    ),

    // Requirement Edge Case 5: Item without optional text (null)
    WorkoutItem(
      id: 'w5',
      title: 'Heavy Deadlift & Squat Workshop',
      category: WorkoutCategory.crossfit,
      when: now.add(const Duration(days: 4)),
      limit: 10,
      names: ['Samat'],
      mode: false,
      venue: 'Powerlifting Box 3',
      optionalText: null,
      favourite: false,
    ),

    WorkoutItem(
      id: 'w6',
      title: 'CrossFit Open WOD Preparation',
      category: WorkoutCategory.crossfit,
      when: now.add(const Duration(days: 3, hours: 2)),
      limit: 12,
      names: ['Arman', 'Dauren'],
      mode: false,
      venue: 'CrossFit Gym 7',
      optionalText: 'Focusing on clean and jerk mechanics.',
      favourite: true,
    ),

    WorkoutItem(
      id: 'w7',
      title: 'Vinyasa Flow Yoga for Beginners',
      category: WorkoutCategory.yoga,
      when: now.add(const Duration(days: 5)),
      limit: 15,
      names: ['Aigerim'],
      mode: false,
      venue: 'Yoga Studio Light',
      optionalText: 'Mats provided at the venue.',
      favourite: false,
    ),

    WorkoutItem(
      id: 'w8',
      title: '5K Pace Running Group',
      category: WorkoutCategory.cardio,
      when: now.add(const Duration(days: 6, hours: 1)),
      limit: 25,
      names: ['Nurzhas Bergenbay', 'Ali'],
      mode: false,
      venue: 'City Stadium',
      optionalText: 'Interval running work on track.',
      favourite: true,
    ),

    WorkoutItem(
      id: 'w9',
      title: 'Online Tabata HIIT Blast',
      category: WorkoutCategory.hiit,
      when: now.add(const Duration(days: 1, hours: 2)),
      limit: 100,
      names: ['Berik'],
      mode: true,
      venue: 'https://meet.google.com/fit-tabata-abc',
      optionalText: 'Fast-paced home workout.',
      favourite: false,
    ),

    WorkoutItem(
      id: 'w10',
      title: 'Upper Body Hypertrophy Session',
      category: WorkoutCategory.strength,
      when: now.add(const Duration(days: 7)),
      limit: 8,
      names: ['Meyrambek', 'Timur', 'Azamat'],
      mode: false,
      venue: 'KBTU Gym Room 2',
      optionalText: 'Chest, shoulders, and triceps focus.',
      favourite: false,
    ),

    WorkoutItem(
      id: 'w11',
      title: 'Mobility & Joint Health Recovery',
      category: WorkoutCategory.yoga,
      when: now.subtract(const Duration(days: 5)),
      limit: 12,
      names: ['Kairat'],
      mode: false,
      venue: 'Recovery Hub',
      optionalText: 'Past recovery clinic.',
      favourite: false,
    ),

    WorkoutItem(
      id: 'w12',
      title: 'Kettlebell & Functional Fitness',
      category: WorkoutCategory.crossfit,
      when: now.add(const Duration(days: 8, hours: 4)),
      limit: 14,
      names: [],
      mode: false,
      venue: 'Functional Zone A',
      optionalText: 'Dynamic movement training.',
      favourite: false,
    ),
  ];
}
