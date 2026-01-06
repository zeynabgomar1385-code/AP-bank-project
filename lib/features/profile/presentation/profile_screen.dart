import 'package:flutter/material.dart';

import '../../../widgets/widgets_imports.dart';
import '../../auth/presentation/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String? initialName;

  final String? initialEmail;
  final String? initialBio;

  const ProfileScreen({
    super.key,
    required this.username,
    this.initialName,
    this.initialEmail,
    this.initialBio,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _bioController;

  bool _isSaving = false;
  bool _editMode = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.initialName ?? '');
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _bioController = TextEditingController(text: widget.initialBio ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  String _initials(String value) {
    final t = value.trim();
    if (t.isEmpty) return 'U';
    final parts = t.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.length == 1) {
      return parts.first.characters.take(1).toString().toUpperCase();
    }
    final a = parts.first.characters.take(1).toString().toUpperCase();
    final b = parts.last.characters.take(1).toString().toUpperCase();
    return '$a$b';
  }

  bool get _hasChanges {
    final n = _nameController.text.trim();
    final e = _emailController.text.trim();
    final b = _bioController.text.trim();
    final n0 = (widget.initialName ?? '').trim();
    final e0 = (widget.initialEmail ?? '').trim();
    final b0 = (widget.initialBio ?? '').trim();
    return n != n0 || e != e0 || b != b0;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_hasChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing changed 🙂')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await Future.delayed(const Duration(milliseconds: 700));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated ✅')),
      );

      setState(() {
        _editMode = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _copyUsername() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Username copied: ${widget.username}')),
    );
  }

  void _fakeChangePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change password (bonus) — not implemented yet')), 
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nameText = _nameController.text.trim().isEmpty
        ? widget.username
        : _nameController.text.trim();
    final initials = _initials(_nameController.text.trim().isEmpty ? widget.username : _nameController.text);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: _editMode ? 'Close' : 'Edit',
            onPressed: () {
              setState(() => _editMode = !_editMode);
            },
            icon: Icon(_editMode ? Icons.close : Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          initials,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nameText,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '@${widget.username}',
                              style: TextStyle(color: theme.hintColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: _copyUsername,
                                  icon: const Icon(Icons.copy, size: 18),
                                  label: const Text('Copy'),
                                ),
                                OutlinedButton.icon(
                                  onPressed: _fakeChangePassword,
                                  icon: const Icon(Icons.lock_outline, size: 18),
                                  label: const Text('Security'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _editMode
                    ? Card(
                        key: const ValueKey('edit'),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Edit Info',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),

                              AppTextField(
                                controller: _nameController,
                                label: 'Name',
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  if (value.trim().length < 2) {
                                    return 'Name is too short';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 12),

                              AppTextField(
                                controller: _emailController,
                                label: 'Email (optional)',
                                validator: (value) {
                                  final v = (value ?? '').trim();
                                  if (v.isEmpty) return null;
                                  if (!v.contains('@') || !v.contains('.')) {
                                    return 'Email looks invalid';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 12),

                              TextFormField(
                                controller: _bioController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'Bio (optional)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              PrimaryButton(
                                text: 'Save changes',
                                isLoading: _isSaving,
                                onPressed: _saveProfile,
                              ),

                              const SizedBox(height: 10),

                              OutlinedButton.icon(
                                onPressed: _logout,
                                icon: const Icon(Icons.logout),
                                label: const Text('Logout'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Card(
                        key: const ValueKey('view'),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Details',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),

                              _InfoRow(title: 'Username', value: widget.username),
                              const SizedBox(height: 10),
                              _InfoRow(title: 'Name', value: nameText),
                              const SizedBox(height: 10),
                              _InfoRow(
                                title: 'Email',
                                value: _emailController.text.trim().isEmpty
                                    ? '(not set)'
                                    : _emailController.text.trim(),
                              ),
                              const SizedBox(height: 10),
                              _InfoRow(
                                title: 'Bio',
                                value: _bioController.text.trim().isEmpty
                                    ? '(not set)'
                                    : _bioController.text.trim(),
                              ),

                              const SizedBox(height: 16),

                              PrimaryButton(
                                text: 'Edit profile',
                                isLoading: false,
                                onPressed: () {
                                  setState(() => _editMode = true);
                                },
                              ),

                              const SizedBox(height: 10),

                              OutlinedButton.icon(
                                onPressed: _logout,
                                icon: const Icon(Icons.logout),
                                label: const Text('Logout'),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 12),

              Text(
                'AP Bank Project • Profile',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: theme.hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            title,
            style: TextStyle(color: theme.hintColor),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
