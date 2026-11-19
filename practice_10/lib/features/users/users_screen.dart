import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import 'user.dart';
import 'users_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<UsersModel>();

    if (m.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bodyWidget = switch (m.error) {
      null => UserList(users: m.items),
      NoConnectionException() => OfflineView(onRetry: m.load),
      NotFoundException() || UnauthorizedException() => const Center(
        child: Text('Access error or resource not found.'),
      ),
      ServerException(:final status) => ServerErrorView(
        status: status,
        onRetry: m.load,
      ),
      BadResponseException() => const Center(
        child: Text('Bad response format from server.'),
      ),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateUserDialog(context),
        child: const Icon(Icons.add),
      ),
      body: bodyWidget,
    );
  }

  void _openCreateUserDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const CreateUserForm(),
    );
  }
}

class UserList extends StatelessWidget {
  const UserList({super.key, required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    final m = context.read<UsersModel>();

    return RefreshIndicator(
      onRefresh: m.load,
      child: ListView.separated(
        itemCount: users.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text('${user.email} • ${user.address.city}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => UserDetailScreen(user: user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Username'),
            subtitle: Text(user.username),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(user.email),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone'),
            subtitle: Text(user.phone),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.web),
            title: const Text('Website'),
            subtitle: Text(user.website ?? 'N/A'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: const Text('Address'),
            subtitle: Text(
              '${user.address.street}, ${user.address.suite}, ${user.address.city}',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Company'),
            subtitle: Text(
              '${user.company.name}\n"${user.company.catchPhrase}"',
            ),
          ),
        ],
      ),
    );
  }
}

class OfflineView extends StatelessWidget {
  const OfflineView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No Internet Connection'),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class ServerErrorView extends StatelessWidget {
  const ServerErrorView({
    super.key,
    required this.status,
    required this.onRetry,
  });

  final int status;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Server Error ($status)'),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class CreateUserForm extends StatefulWidget {
  const CreateUserForm({super.key});

  @override
  State<CreateUserForm> createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final m = context.read<UsersModel>();
    final draft = User(
      id: 0,
      name: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      address: const Address(
        street: 'KBTU St',
        suite: 'Suite 100',
        city: 'Almaty',
        zipcode: '050000',
        geo: Geo(lat: 43.238949, lng: 76.945465),
      ),
      phone: '+7 700 000 0000',
      website: 'kbtu.kz',
      company: (name: 'KBTU Corp', catchPhrase: 'Education First'),
    );

    final success = await m.addUser(draft);
    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save user. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.select<UsersModel, bool>((m) => m.isSaving);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (v) =>
                  (v == null || !v.contains('@')) ? 'Invalid email' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isSaving ? null : _submit,
              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
