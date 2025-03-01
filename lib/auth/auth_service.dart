import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //  Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //  Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Sign In Error: $e");
      return null;
    }
  }

  //  Register new user (Sign Up)
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Sign Up Error: $e");
      return null;
    }
  }

  //  Password reset (Send reset email)
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent.");
    } catch (e) {
      print("Password Reset Error: $e");
    }
  }

  //  Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
