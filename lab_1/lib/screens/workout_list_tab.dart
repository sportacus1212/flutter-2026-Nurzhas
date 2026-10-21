import 'package:flutter/material.dart';

import '../models/workout_category.dart';
import '../models/workout_item.dart';
import '../widgets/empty_state.dart';
import '../widgets/workout_card.dart';

// R21: Main workout list tab with search, ChoiceChips, FilterChip, and List/Grid
class WorkoutListTab extends StatefulWidget {
  final List<WorkoutItem> items;
  final Function(WorkoutItem) onItemTap;
  final Function(String) onToggleFavourite;
  final VoidCallback onAddPressed;

  const WorkoutListTab({
    super.key,
    required this.items,
    required this.onItemTap,
    required this.onToggleFavourite,
    required this.onAddPressed,
  });

  @override
  State<WorkoutListTab> createState() => _WorkoutListTabState();
}

class _WorkoutListTabState extends State<WorkoutListTab> {
  final TextEditingController _searchController = TextEditingController();
  WorkoutCategory? _selectedCategory;
  bool _showPastOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<WorkoutItem> get _filteredItems {
    final query = _searchController.text.trim().toLowerCase();

    // R7: Functional query filtering using where and collection methods
    return widget.items.where((item) {
      final matchesSearch =
          query.isEmpty || item.title.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == null || item.category == _selectedCategory;
      final matchesPast = !_showPastOnly || item.isPast;

      return matchesSearch && matchesCategory && matchesPast;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search workouts...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedCategory == null,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = null;
                      });
                    }
                  },
                ),
                const SizedBox(width: 8),
                ...WorkoutCategory.values.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      avatar: Icon(cat.icon, size: 18),
                      label: Text(cat.label),
                      selected: _selectedCategory == cat,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? cat : null;
                        });
                      },
                    ),
                  );
                }),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Past Only'),
                  selected: _showPastOnly,
                  onSelected: (selected) {
                    setState(() {
                      _showPastOnly = selected;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? EmptyStateView(
                    icon: Icons.search_off,
                    message: 'No workout sessions match your filter criteria.',
                    buttonLabel: 'Clear Search',
                    onButtonPressed: () {
                      setState(() {
                        _searchController.clear();
                        _selectedCategory = null;
                        _showPastOnly = false;
                      });
                    },
                  )
                : LayoutBuilder(
                    // R20: LayoutBuilder decides between ListView and GridView
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 600) {
                        return GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 360,
                                childAspectRatio: 2.2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return WorkoutCard(
                              item: item,
                              onTap: () => widget.onItemTap(item),
                              onToggleFavourite: () =>
                                  widget.onToggleFavourite(item.id),
                            );
                          },
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return WorkoutCard(
                            item: item,
                            onTap: () => widget.onItemTap(item),
                            onToggleFavourite: () =>
                                widget.onToggleFavourite(item.id),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAddPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
