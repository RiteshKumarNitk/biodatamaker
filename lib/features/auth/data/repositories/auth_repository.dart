import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:biodata_maker/core/services/hive_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/auth/data/models/user.dart';

class AuthRepository {
  final HiveService _hiveService;
  String? _currentUserId;
  static const _currentUserIdKey = 'current_user_id';

  AuthRepository({HiveService? hiveService})
      : _hiveService = hiveService ?? sl<HiveService>();

  Future<void> _persistUserId() async {
    final box = await Hive.openBox('auth_session');
    if (_currentUserId != null) {
      await box.put(_currentUserIdKey, _currentUserId);
    } else {
      await box.delete(_currentUserIdKey);
    }
  }

  Future<void> _restoreUserId() async {
    if (_currentUserId != null) return;
    final box = await Hive.openBox('auth_session');
    final savedId = box.get(_currentUserIdKey) as String?;
    if (savedId != null && _hiveService.getUser(savedId) != null) {
      _currentUserId = savedId;
    }
  }

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
    await _persistUserId();
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
      await _persistUserId();
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
    await _persistUserId();
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
    await _persistUserId();
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
    await _persistUserId();
    return user;
  }

  Future<void> signOut() async {
    _currentUserId = null;
    await _persistUserId();
  }

  Future<User?> getCurrentUser() async {
    await _restoreUserId();
    if (_currentUserId != null) {
      final user = _hiveService.getUser(_currentUserId!);
      if (user != null) return user;
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    await _restoreUserId();
    return _currentUserId != null && _hiveService.getUser(_currentUserId!) != null;
  }

  Future<void> updateProfile(User user) async {
    await _hiveService.saveUser(user);
    _currentUserId = user.id;
    await _persistUserId();
  }
}
