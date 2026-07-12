import 'package:uuid/uuid.dart';

import 'package:biodata_maker/core/services/hive_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/auth/data/models/user.dart';

class AuthRepository {
  final HiveService _hiveService;
  String? _currentUserId;

  AuthRepository({HiveService? hiveService})
      : _hiveService = hiveService ?? sl<HiveService>();

  Future<User> signUp(String name, String email, String phone) async {
    final now = DateTime.now();
    final user = User(
      id: const Uuid().v4(),
      name: name,
      email: email,
      phone: phone,
      createdAt: now,
      lastLoginAt: now,
    );
    await _hiveService.saveUser(user);
    _currentUserId = user.id;
    return user;
  }

  Future<User> signInWithEmail(String email) async {
    final users = _hiveService.getAllUsers();
    final existing = users.where((u) => u.email == email);
    if (existing.isNotEmpty) {
      final user = existing.first;
      final updated = user.copyWith(
        lastLoginAt: DateTime.now(),
        loginCount: user.loginCount + 1,
      );
      await _hiveService.saveUser(updated);
      _currentUserId = updated.id;
      return updated;
    }
    final now = DateTime.now();
    final user = User(
      id: const Uuid().v4(),
      name: email.split('@').first,
      email: email,
      createdAt: now,
      lastLoginAt: now,
    );
    await _hiveService.saveUser(user);
    _currentUserId = user.id;
    return user;
  }

  Future<User> signInWithGoogle() async {
    final now = DateTime.now();
    final user = User(
      id: const Uuid().v4(),
      name: 'Google User',
      email: 'google_user_${now.millisecondsSinceEpoch}@gmail.com',
      createdAt: now,
      lastLoginAt: now,
    );
    await _hiveService.saveUser(user);
    _currentUserId = user.id;
    return user;
  }

  Future<User> signInAsGuest() async {
    final now = DateTime.now();
    final user = User(
      id: const Uuid().v4(),
      name: 'Guest',
      isGuest: true,
      createdAt: now,
      lastLoginAt: now,
    );
    await _hiveService.saveUser(user);
    _currentUserId = user.id;
    return user;
  }

  Future<void> signOut() async {
    if (_currentUserId != null) {
      await _hiveService.deleteUser(_currentUserId!);
      _currentUserId = null;
    }
  }

  User? getCurrentUser() {
    if (_currentUserId != null) {
      final user = _hiveService.getUser(_currentUserId!);
      if (user != null) return user;
    }
    final users = _hiveService.getAllUsers();
    if (users.isNotEmpty) {
      _currentUserId = users.first.id;
      return users.first;
    }
    return null;
  }

  bool isLoggedIn() {
    if (_currentUserId != null) return true;
    final users = _hiveService.getAllUsers();
    if (users.isNotEmpty) {
      _currentUserId = users.first.id;
      return true;
    }
    return false;
  }

  Future<void> updateProfile(User user) async {
    await _hiveService.saveUser(user);
    _currentUserId = user.id;
  }
}
