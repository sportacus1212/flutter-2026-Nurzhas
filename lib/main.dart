import 'package:flutter/material.dart';
import 'data.dart';
import 'info_row.dart';
import 'profile_header.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My profile'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                ProfileHeader(
                  name: myName,
                  university: myUniversity,
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),
                for (final fact in facts)
                  InfoRow(
                    label: fact.label,
                    value: fact.value,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}