import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:biodata_maker/features/auth/data/models/user.dart';
import 'package:biodata_maker/features/auth/data/repositories/auth_repository.dart';
import 'package:biodata_maker/features/biodata/data/repositories/biodata_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthRepository _authRepo = sl<AuthRepository>();
  final BiodataRepository _biodataRepo = sl<BiodataRepository>();

  User? _user;
  int _totalBiodatas = 0;
  int _totalDownloads = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = await _authRepo.getCurrentUser();
    final biodatas = await _biodataRepo.getAllScoped();
    _totalBiodatas = biodatas.length;
    _totalDownloads =
        biodatas.fold<int>(0, (sum, b) => sum + b.downloadCount);
    if (mounted) setState(() => _user = user);
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  void _showEditDialog() {
    final nameController = TextEditingController(text: _user?.name ?? '');
    final emailController = TextEditingController(text: _user?.email ?? '');
    final phoneController = TextEditingController(text: _user?.phone ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(Strings.tr('Edit Profile')),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: Strings.tr('Name')),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? Strings.tr('Name is required') : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: Strings.tr('Email')),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return null; // email optional
                  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                  if (!emailRegex.hasMatch(value)) {
                    return Strings.tr('Enter a valid email');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: Strings.tr('Phone')),
                keyboardType: TextInputType.phone,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return null; // phone optional
                  if (value.length < 7) return Strings.tr('Enter a valid phone number');
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(Strings.tr('Cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!(formKey.currentState?.validate() ?? false)) return;
              if (_user != null) {
                final updated = _user!.copyWith(
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  phone: phoneController.text.trim(),
                );
                await _authRepo.updateProfile(updated);
                if (mounted) setState(() => _user = updated);
                if (ctx.mounted) Navigator.of(ctx).pop();
              }
            },
            child: Text(Strings.tr('Save')),
          ),
        ],
      ),
    );
  }

  /// Confirms before signing out — one accidental tap should not wipe the
  /// session.
  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(Strings.tr('Logout')),
        content: Text(Strings.tr('Are you sure you want to sign out?')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(Strings.tr('Cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              Strings.tr('Logout'),
              style: TextStyle(color: Theme.of(ctx).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await _authRepo.signOut();
      if (mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(Strings.tr('Profile'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: colorScheme.primary,
                  child: Text(
                    _getInitials(_user?.name ?? ''),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 36,
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _user?.name ?? 'Guest',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_user?.email != null && _user!.email.isNotEmpty)
                  Text(
                    _user!.email,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                if (_user?.phone != null && _user!.phone.isNotEmpty)
                  Text(
                    _user!.phone,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, duration: 400.ms),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                  child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    child: Column(
                      children: [
                        Text(
                          '$_totalBiodatas',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          Strings.tr('Total Biodatas'),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 0.ms).slideY(begin: 0.2, duration: 400.ms),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    child: Column(
                      children: [
                        Text(
                          '$_totalDownloads',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          Strings.tr('Downloads'),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, duration: 400.ms),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(Strings.tr('Edit Profile')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showEditDialog,
                ).animate().fadeIn(delay: 0.ms).slideX(begin: 0.1),
                const Divider(height: 1),
                if (_user?.email == 'admin@biodata.com')
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings_outlined),
                    title: const Text('Admin Panel'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/admin/dashboard'),
                  ).animate().fadeIn(delay: 50.ms).slideX(begin: 0.1),

                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: Text(Strings.tr('Settings')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/settings'),
                ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.share_outlined),
                  title: Text(Strings.tr('Share App')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    SharePlus.instance.share(
                      ShareParams(text: Strings.tr('Check out Biodata Maker app!')),
                    );
                  },
                ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.logout, color: colorScheme.error),
                  title: Text(Strings.tr('Logout'),
                      style: TextStyle(color: colorScheme.error)),
                  onTap: _confirmLogout,
                ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
