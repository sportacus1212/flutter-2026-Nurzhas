import 'package:flutter/material.dart';

import '../main.dart';
import '../models/user_profile.dart';
import '../models/workout_item.dart';

// R38: Profile tab with controller validation and list participation counter
class ProfileTab extends StatefulWidget {
  final UserProfile profile;
  final List<WorkoutItem> items;
  final Function(UserProfile) onUpdateProfile;

  const ProfileTab({
    super.key,
    required this.profile,
    required this.items,
    required this.onUpdateProfile,
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late TextEditingController _nameController;
  late TextEditingController _groupController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _groupController = TextEditingController(text: widget.profile.group);
  }

  @override
  void didUpdateWidget(ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _nameController.text = widget.profile.name;
      _groupController.text = widget.profile.group;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updated = widget.profile.copyWith(
        name: _nameController.text.trim(),
        group: _groupController.text.trim(),
      );
      widget.onUpdateProfile(updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final myAppState = MyApp.of(context);

    // R38: Dynamic count of sessions where user is registered
    final userCount = widget.items
        .where((item) => item.containsName(widget.profile.name))
        .length;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          widget.profile.name.isNotEmpty
                              ? widget.profile.name[0].toUpperCase()
                              : '?',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.profile.name.isEmpty
                                  ? 'Unnamed User'
                                  : widget.profile.name,
                              style: theme.textTheme.titleLarge,
                            ),
                            Text(
                              'Group: ${widget.profile.group.isEmpty ? 'N/A' : widget.profile.group}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'You are on $userCount lists',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('User Information', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (_) => _saveProfile(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _groupController,
                decoration: const InputDecoration(
                  labelText: 'Group',
                  border: OutlineInputBorder(),
                  hintText: 'e.g. IS-2101',
                ),
                // R38: RegExp validator for student group format
                validator: (val) {
                  if (val == null || val.isEmpty) return null;
                  final regExp = RegExp(r'^[A-Z]{2,4}-\d{4}$');
                  if (!regExp.hasMatch(val)) {
                    return 'Format must match pattern like IS-2101';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _saveProfile(),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveProfile,
                  child: const Text('Save Profile'),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              Text('Theme Mode', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              // R22: ChoiceChips controlling ThemeMode
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChoiceChip(
                    label: const Text('System'),
                    selected: myAppState.themeMode == ThemeMode.system,
                    onSelected: (_) =>
                        myAppState.setThemeMode(ThemeMode.system),
                  ),
                  ChoiceChip(
                    label: const Text('Light'),
                    selected: myAppState.themeMode == ThemeMode.light,
                    onSelected: (_) => myAppState.setThemeMode(ThemeMode.light),
                  ),
                  ChoiceChip(
                    label: const Text('Dark'),
                    selected: myAppState.themeMode == ThemeMode.dark,
                    onSelected: (_) => myAppState.setThemeMode(ThemeMode.dark),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
