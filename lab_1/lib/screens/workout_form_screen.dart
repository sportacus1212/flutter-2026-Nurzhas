import 'package:flutter/material.dart';

import '../models/workout_category.dart';
import '../models/workout_item.dart';
import '../utils/format.dart';

class WorkoutFormScreen extends StatefulWidget {
  final WorkoutItem? initialItem;

  const WorkoutFormScreen({super.key, this.initialItem});

  @override
  State<WorkoutFormScreen> createState() => _WorkoutFormScreenState();
}

class _WorkoutFormScreenState extends State<WorkoutFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // R35: Controllers and FocusNodes as State fields created once and disposed
  late TextEditingController _titleController;
  late TextEditingController _venueController;
  late TextEditingController _limitController;
  late TextEditingController _optionalTextController;

  late WorkoutCategory _selectedCategory;
  late DateTime _selectedDateTime;
  late bool _isOnlineMode;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem ?? WorkoutItem.empty();

    _titleController = TextEditingController(text: item.title);
    _venueController = TextEditingController(text: item.venue);
    _limitController = TextEditingController(text: item.limit.toString());
    _optionalTextController = TextEditingController(
      text: item.optionalText ?? '',
    );

    _selectedCategory = item.category;
    _selectedDateTime = item.when;
    _isOnlineMode = item.mode;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _venueController.dispose();
    _limitController.dispose();
    _optionalTextController.dispose();
    super.dispose();
  }

  // R30: PopScope dirty check comparing current inputs against initial state
  bool get _isDirty {
    final item = widget.initialItem;
    if (item == null) {
      return _titleController.text.isNotEmpty ||
          _venueController.text.isNotEmpty ||
          _optionalTextController.text.isNotEmpty;
    }
    return _titleController.text != item.title ||
        _venueController.text != item.venue ||
        _limitController.text != item.limit.toString() ||
        _optionalTextController.text != (item.optionalText ?? '') ||
        _selectedCategory != item.category ||
        _isOnlineMode != item.mode ||
        _selectedDateTime != item.when;
  }

  void _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      // R36: Cancel leaves existing DateTime untouched
      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      // R17: Simulated 1-second delay for save operation
      await Future.delayed(const Duration(seconds: 1));

      // R14 & R17: mounted check before pop
      if (!mounted) return;

      final newItem = WorkoutItem(
        id:
            widget.initialItem?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        category: _selectedCategory,
        when: _selectedDateTime,
        limit: int.parse(_limitController.text.trim()),
        names: widget.initialItem?.names ?? [],
        mode: _isOnlineMode,
        venue: _venueController.text.trim(),
        optionalText: _optionalTextController.text.trim().isEmpty
            ? null
            : _optionalTextController.text.trim(),
        favourite: widget.initialItem?.favourite ?? false,
      );

      Navigator.pop(context, newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialItem != null;

    // R30: PopScope protects unsaved form changes
    return PopScope(
      canPop: !_isDirty || _isSaving,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Discard Changes?'),
            content: const Text(
              'You have unsaved changes. Are you sure you want to leave?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Discard'),
              ),
            ],
          ),
        );

        if (shouldPop == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(isEditing ? 'Edit Workout' : 'New Workout')),
        // R35: Dismiss keyboard on outer tap
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // R37: ScrollView prevents pixel overflow when keyboard is visible
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // R34: Title validator requiring 3 to 60 characters
                TextFormField(
                  controller: _titleController,
                  maxLength: 60,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Session Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().length < 3) {
                      return 'Title must be at least 3 characters';
                    }
                    if (val.trim().length > 60) {
                      return 'Title cannot exceed 60 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<WorkoutCategory>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: WorkoutCategory.values.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Row(
                        children: [
                          Icon(cat.icon, size: 20),
                          const SizedBox(width: 8),
                          Text(cat.label),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (cat) {
                    if (cat != null) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Online Mode'),
                  subtitle: Text(
                    _isOnlineMode
                        ? 'Venue is a meeting link'
                        : 'Physical location venue',
                  ),
                  value: _isOnlineMode,
                  onChanged: (val) {
                    setState(() {
                      _isOnlineMode = val;
                    });
                  },
                ),
                const SizedBox(height: 12),
                // R34: Venue validator requiring link format when online mode is active
                TextFormField(
                  controller: _venueController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: _isOnlineMode
                        ? 'Online Link (URL)'
                        : 'Venue Location',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Location field is required';
                    }
                    if (_isOnlineMode && !val.contains('://')) {
                      return 'Online mode requires a valid URL containing "://"';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                // R34: Capacity limit validator (1-500, cannot be lower than existing count)
                TextFormField(
                  controller: _limitController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Capacity Limit',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Limit is required';
                    }
                    final num = int.tryParse(val.trim());
                    if (num == null || num < 1 || num > 500) {
                      return 'Limit must be a number between 1 and 500';
                    }
                    final currentCount = widget.initialItem?.count ?? 0;
                    if (num < currentCount) {
                      return 'Limit cannot be below current attendees ($currentCount)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                // R36: Readonly date field opening showDatePicker
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: DateFormatter.formatDateTime(_selectedDateTime),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Date & Time',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _optionalTextController,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Optional Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    // R17: onPressed disabled during save operation
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEditing ? 'Save Changes' : 'Create Workout'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
