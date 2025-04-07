import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // ✅ Sign in with email and password

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("🚨 Sign In Error: $e");
      return null;
    }
  }

  // ✅ Register new user (Sign Up) + Save to Firestore
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        DocumentReference userDoc = _firestore.collection('users').doc(user.uid);

        // 🔹 Ensure document is created only if it doesn’t exist
        bool docExists = (await userDoc.get()).exists;

        if (!docExists) {
          await userDoc.set({
            'email': email,
            'character': '',
            'pet': '',
            'coins': 0,
            'createdAt': FieldValue.serverTimestamp(),
          });
          print("✔️ User registered and stored in Firestore!");
        } else {
          print("⚠️ User document already exists.");
        }
      } else {
        print("🚨 Firebase user creation failed!");
      }

      return user;
    } catch (e) {
      print("🚨 Sign Up Error: $e");
      return null;
    }
  }

  // ✅ Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("✔️ Password reset email sent.");
    } catch (e) {
      print("🚨 Password Reset Error: $e");
    }
  }

  // ✅ Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    print("✔️ User signed out.");
  }
}
