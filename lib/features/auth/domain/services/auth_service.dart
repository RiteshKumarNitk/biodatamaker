import 'package:biodata_maker/features/auth/data/models/user.dart';
import 'package:biodata_maker/features/auth/data/repositories/auth_repository.dart';
import 'package:biodata_maker/core/services/service_locator.dart';

class AuthService {

  /// Prompts the user to sign in with Google.
  /// If successful, saves the user to local storage and returns the User object.
  Future<User?> signInWithGoogle() async {
    try {
      final authRepo = sl<AuthRepository>();
      final user = await authRepo.signInWithGoogle();
      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Signs out the current Google user.
  Future<void> signOut() async {
    try {
      final authRepo = sl<AuthRepository>();
      await authRepo.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
