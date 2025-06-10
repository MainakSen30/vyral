import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/authentication/domain/entities/app_user.dart';
import 'package:social_media_app/features/authentication/domain/repository/auth_repo.dart';

class FireBaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      //user credenntials

      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: '',
      );
      //save user data in firestore.
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());
      return user;
    } catch (e) {
      //catch any errors that occur during the login process.
      //print('Firestore Login Error: $e'); // Add this line
      throw Exception('Login failed! ${e.toString()}');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      //user credenntials

      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );
      // Save user data in firestore
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());
      return user;
    } catch (e) {
      //print('Firestore Register Error: $e'); // Add this line
      throw Exception('Login failed! ${e.toString()}');
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Logout failed! ${e.toString()}');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!, name: '');
  }
}
