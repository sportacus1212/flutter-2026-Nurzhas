import 'dart:async';

import 'package:flutter/material.dart';

import '../models/countdown.dart';
import '../models/workout_item.dart';
import '../utils/format.dart';

class WorkoutDetailArgs {
  final WorkoutItem item;
  final String currentUserName;
  final Function(String id, String name) onRegister;
  final Function(String id, String name) onUnregister;
  final Function(WorkoutItem item) onEdit;
  final Function(String id) onDelete;
  final VoidCallback onNavigateToProfile;

  WorkoutDetailArgs({
    required this.item,
    required this.currentUserName,
    required this.onRegister,
    required this.onUnregister,
    required this.onEdit,
    required this.onDelete,
    required this.onNavigateToProfile,
  });
}

class WorkoutDetailScreen extends StatefulWidget {
  final WorkoutDetailArgs args;

  const WorkoutDetailScreen({super.key, required this.args});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  Timer? _timer;
  late WorkoutItem _currentItem;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.args.item;
    // R13: Periodic 1-minute timer updating the countdown
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // R13: Cancel timer on dispose
    _timer?.cancel();
    super.dispose();
  }

  void _handleJoinToggle() async {
    final name = widget.args.currentUserName.trim();

    // R15: Empty profile name check with SnackBar callback to profile tab
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please set your name in Profile before joining'),
          action: SnackBarAction(
            label: 'Profile',
            onPressed: () {
              Navigator.pop(context);
              widget.args.onNavigateToProfile();
            },
          ),
        ),
      );
      return;
    }

    final isJoined = _currentItem.containsName(name);
    final actionText = isJoined ? 'Leave' : 'Join';

    // R15: Confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$actionText Session?'),
        content: Text(
          'Are you sure you want to $actionText "${_currentItem.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      if (isJoined) {
        widget.args.onUnregister(_currentItem.id, name);
        setState(() {
          final updated = List<String>.from(_currentItem.names)..remove(name);
          _currentItem = _currentItem.copyWith(names: updated);
        });
      } else {
        widget.args.onRegister(_currentItem.id, name);
        setState(() {
          final updated = List<String>.from(_currentItem.names)..add(name);
          _currentItem = _currentItem.copyWith(names: updated);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = _currentItem.category.getColor(theme.colorScheme);
    final isJoined = _currentItem.containsName(widget.args.currentUserName);
    final countdown = calculateCountdown(_currentItem.when);

    // R9: Render countdown using exhaustive switch expression
    final countdownText = switch (countdown) {
      UpcomingCountdown(remaining: final d) =>
        'Starts in ${DateFormatter.formatDuration(d)}',
      StartedCountdown(elapsed: final d) => 'Started ${d.inMinutes}m ago',
      EndedCountdown() => 'Session Ended',
    };

    return Scaffold(
      // R31: No BackButton or leading property anywhere
      appBar: AppBar(
        title: Text(_currentItem.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) async {
              if (val == 'edit') {
                widget.args.onEdit(_currentItem);
              } else if (val == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Session?'),
                    content: const Text('This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                // R14: Check mounted before using context/Navigator
                if (confirm == true && mounted) {
                  widget.args.onDelete(_currentItem.id);
                  Navigator.pop(context);
                }
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // R24: Header Stack with banner color and overlay icons
          Stack(
            children: [
              Container(
                height: 140,
                width: double.infinity,
                color: categoryColor.withAlpha(40),
                child: Center(
                  child: Icon(
                    _currentItem.category.icon,
                    size: 72,
                    color: categoryColor,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Chip(
                  avatar: Icon(_currentItem.category.icon, size: 16),
                  label: Text(_currentItem.category.label),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceColorBrightness,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    countdownText,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // R29: DefaultTabController with TabBar and TabBarView
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      const Tab(text: 'About'),
                      Tab(text: 'Participants (${_currentItem.count})'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.calendar_today),
                                title: const Text('Date & Time'),
                                subtitle: Text(
                                  DateFormatter.formatDateTime(
                                    _currentItem.when,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  _currentItem.mode
                                      ? Icons.link
                                      : Icons.location_on,
                                ),
                                title: Text(
                                  _currentItem.mode ? 'Online Link' : 'Venue',
                                ),
                                subtitle: Text(_currentItem.venue),
                              ),
                              ListTile(
                                leading: const Icon(Icons.group),
                                title: const Text('Capacity'),
                                subtitle: Text(
                                  '${_currentItem.count} / ${_currentItem.limit} spots taken',
                                ),
                              ),
                              // R6: Optional text rendered using collection if
                              if (_currentItem.optionalText != null) ...[
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Text(
                                    'Description',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                                Text(_currentItem.optionalText!),
                              ],
                            ],
                          ),
                        ),
                        // Participants list tab
                        ListView.builder(
                          itemCount: _currentItem.names.length,
                          itemBuilder: (ctx, index) {
                            final name = _currentItem.names[index];
                            final isMe = name == widget.args.currentUserName;
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(
                                name,
                                style: TextStyle(
                                  fontWeight: isMe
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              trailing: isMe
                                  ? Chip(
                                      label: const Text('You'),
                                      backgroundColor:
                                          theme.colorScheme.primaryContainer,
                                    )
                                  : null,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Primary action bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                // R16: Button disabled when full (unless user is already joined)
                onPressed: (_currentItem.isFull && !isJoined)
                    ? null
                    : _handleJoinToggle,
                child: Text(
                  _currentItem.isFull && !isJoined
                      ? 'Session Full'
                      : (isJoined ? 'Leave Session' : 'Register / Join'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on ColorScheme {
  Color get surfaceColorBrightness => surface;
}
