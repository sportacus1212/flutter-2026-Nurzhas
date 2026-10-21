import 'package:flutter/material.dart';

import '../models/workout_item.dart';
import '../utils/format.dart';

// R18: Reusable card widget with Stack avatar and content column
class WorkoutCard extends StatelessWidget {
  final WorkoutItem item;
  final VoidCallback onTap;
  final VoidCallback onToggleFavourite;

  const WorkoutCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onToggleFavourite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = item.category.getColor(theme.colorScheme);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // R19: Stack avatar with Positioned badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: categoryColor.withAlpha(50),
                    child: Icon(
                      item.category.icon,
                      color: categoryColor,
                      size: 28,
                    ),
                  ),
                  // R19: Collection if for FULL / remaining badge
                  if (item.isFull)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'FULL',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onError,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  else if (item.freePlaces <= 5)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${item.freePlaces} left',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onTertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // Main content column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormatter.formatDateTime(item.when),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.mode ? 'Online: ${item.venue}' : item.venue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              // Favourite toggle button on the right
              IconButton(
                icon: Icon(
                  item.favourite ? Icons.favorite : Icons.favorite_border,
                  color: item.favourite ? theme.colorScheme.primary : null,
                ),
                onPressed: onToggleFavourite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
