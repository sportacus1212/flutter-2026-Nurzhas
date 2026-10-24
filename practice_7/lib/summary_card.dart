import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String name;
  final String email;
  final String group;
  final String birthDate;

  const SummaryCard({
    super.key,
    required this.name,
    required this.email,
    required this.group,
    required this.birthDate,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Name'),
        subtitle: Text(name),
      ),
      ListTile(
        leading: const Icon(Icons.email),
        title: const Text('Email'),
        subtitle: Text(email),
      ),
      ListTile(
        leading: const Icon(Icons.group),
        title: const Text('Group'),
        subtitle: Text(group),
      ),
      ListTile(
        leading: const Icon(Icons.cake),
        title: const Text('Date of Birth'),
        subtitle: Text(birthDate),
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 4,
                physics: const NeverScrollableScrollPhysics(),
                children: items,
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: items,
            );
          },
        ),
      ),
    );
  }
}