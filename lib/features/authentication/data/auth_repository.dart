import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/features/authentication/domain/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<AppUser?> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      AppUser appUser =
          AppUser(uid: userCredential.user!.uid, email: email, name: '');
      return appUser;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<AppUser?> registerWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      AppUser appUser =
          AppUser(uid: userCredential.user!.uid, email: email, name: name);

      await firebaseFirestore
          .collection('users')
          .doc(appUser.uid)
          .set(appUser.toJson());
      return appUser;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    firebaseAuth.signOut();
  }

  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!, name: '');
  }
}
