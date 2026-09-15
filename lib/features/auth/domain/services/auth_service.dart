import 'package:google_sign_in/google_sign_in.dart';
import 'package:biodata_maker/features/auth/data/models/user.dart';
import 'package:biodata_maker/features/auth/data/repositories/auth_repository.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Prompts the user to sign in with Google.
  /// If successful, saves the user to local storage and returns the User object.
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        // User canceled the sign-in flow.
        return null;
      }

      // We have a successful sign-in.
      final user = User(
        id: account.id.isNotEmpty ? account.id : const Uuid().v4(),
        name: account.displayName ?? 'Google User',
        email: account.email,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      final authRepo = sl<AuthRepository>();
      await authRepo.saveUser(user);
      await authRepo.setCurrentUser(user.id);
      
      return user;
    } catch (e) {
      // In development, this may throw a PlatformException if google-services.json
      // or SHA-1 is not correctly configured.
      rethrow;
    }
  }

  /// Signs out the current Google user.
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      final authRepo = sl<AuthRepository>();
      await authRepo.logout();
    } catch (e) {
      rethrow;
    }
  }
}
