import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:biodata_maker/core/services/hive_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/auth/data/models/user.dart';

class AuthRepository {
  final HiveService _hiveService;
  GoogleSignIn? _googleSignInInstance;
  
  GoogleSignIn get _googleSignIn {
    _googleSignInInstance ??= GoogleSignIn(scopes: ['email', 'profile']);
    return _googleSignInInstance!;
  }
  
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
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        throw Exception('Sign-in aborted by user');
      }

      final users = _hiveService.getAllUsers();
      final existing = users.where((u) => u.email == account.email);
      
      if (existing.isNotEmpty) {
        final user = existing.first;
        final updated = user.copyWith(
          lastLoginAt: DateTime.now(),
          loginCount: user.loginCount + 1,
          name: account.displayName ?? user.name,
        );
        await _hiveService.saveUser(updated);
        _currentUserId = updated.id;
        await _persistUserId();
        return updated;
      }

      final now = DateTime.now();
      final user = User(
        id: account.id.isNotEmpty ? account.id : const Uuid().v4(),
        name: account.displayName ?? 'Google User',
        email: account.email,
        createdAt: now,
        lastLoginAt: now,
      );
      
      await _hiveService.saveUser(user);
      _currentUserId = user.id;
      await _persistUserId();
      return user;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
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
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (_) {}
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
