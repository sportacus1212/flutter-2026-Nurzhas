import 'package:flutter/material.dart';
import 'models/book.dart';

enum BookAction { toggleRead, delete }

class DetailScreen extends StatelessWidget {
  final Book book;

  const DetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final yearText = book.year != null ? '${book.year}' : 'Year unknown';

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Author: ${book.author}', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Pages: ${book.pages}', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text('Year: $yearText', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text(
              'Status: ${book.read ? 'Read' : 'Unread'}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: book.read
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context, BookAction.toggleRead);
                },
                child: Text(book.read ? 'Mark as unread' : 'Mark as read'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Delete "${book.title}"?'),
                      content: const Text(
                          'Are you sure you want to delete this book?'),
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

                  if (confirm == true && context.mounted) {
                    Navigator.pop(context, BookAction.delete);
                  }
                },
                child: const Text('Delete'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}