import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/user_profile.dart';
import '../models/workout_item.dart';
import '../routes.dart';
import '../widgets/app_drawer.dart';
import 'profile_tab.dart';
import 'workout_detail_screen.dart';
import 'workout_list_tab.dart';

// R10: Root Navigation Shell hosting Item and Profile State
class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _currentIndex = 0;
  late List<WorkoutItem> _items;
  late UserProfile _profile;

  @override
  void initState() {
    super.initState();
    _items = getInitialSeedItems();
    _profile = initialProfile;
  }

  void _toggleFavourite(String id) {
    setState(() {
      _items = _items.map((item) {
        if (item.id == id) {
          return item.copyWith(favourite: !item.favourite);
        }
        return item;
      }).toList();
    });
  }

  void _registerUser(String id, String name) {
    setState(() {
      _items = _items.map((item) {
        if (item.id == id && !item.containsName(name)) {
          final updatedNames = List<String>.from(item.names)..add(name);
          return item.copyWith(names: updatedNames);
        }
        return item;
      }).toList();
    });
  }

  void _unregisterUser(String id, String name) {
    setState(() {
      _items = _items.map((item) {
        if (item.id == id && item.containsName(name)) {
          final updatedNames = List<String>.from(item.names)..remove(name);
          return item.copyWith(names: updatedNames);
        }
        return item;
      }).toList();
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _items = _items.where((item) => item.id != id).toList();
    });
  }

  void _saveItem(WorkoutItem item) {
    setState(() {
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index >= 0) {
        _items[index] = item;
      } else {
        _items.insert(0, item);
      }
    });
  }

  // R27: Caller awaits pushNamed<WorkoutItem>, checks null and mounted, then updates state
  void _openForm([WorkoutItem? item]) async {
    final result = await Navigator.pushNamed<WorkoutItem?>(
      context,
      Routes.form,
      arguments: item,
    );

    if (result != null && mounted) {
      _saveItem(result);
    }
  }

  void _openDetail(WorkoutItem item) {
    Navigator.pushNamed(
      context,
      Routes.detail,
      arguments: WorkoutDetailArgs(
        item: item,
        currentUserName: _profile.name,
        onRegister: _registerUser,
        onUnregister: _unregisterUser,
        onEdit: (editableItem) {
          Navigator.pop(context);
          _openForm(editableItem);
        },
        onDelete: _deleteItem,
        onNavigateToProfile: () {
          setState(() {
            _currentIndex = 2;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tab 2 favorites list
    final favouriteItems = _items.where((i) => i.favourite).toList();

    final tabs = [
      WorkoutListTab(
        items: _items,
        onItemTap: _openDetail,
        onToggleFavourite: _toggleFavourite,
        onAddPressed: () => _openForm(),
      ),
      WorkoutListTab(
        items: favouriteItems,
        onItemTap: _openDetail,
        onToggleFavourite: _toggleFavourite,
        onAddPressed: () => _openForm(),
      ),
      ProfileTab(
        profile: _profile,
        items: _items,
        onUpdateProfile: (updated) {
          setState(() {
            _profile = updated;
          });
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? 'Workouts'
              : (_currentIndex == 1 ? 'Favourites' : 'Profile'),
        ),
      ),
      drawer: AppDrawer(
        onResetData: () {
          setState(() {
            _items = getInitialSeedItems();
            _profile = initialProfile;
          });
        },
      ),
      body: IndexedStack(index: _currentIndex, children: tabs),
      // R10: NavigationBar controlling tabs
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
