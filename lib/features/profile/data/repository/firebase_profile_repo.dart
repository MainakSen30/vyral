//this will have all the information about the user and its methods
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/domain/repository/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      //user document from firestore
      final userDocument = await firebaseFirestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (userDocument.exists) {
        final userData = userDocument.data()!;
        return ProfileUser(
          uid: FirebaseAuth.instance.currentUser!.uid,
          email: userData['email'],
          name: userData['name'],
          bio: userData['bio'] ?? '',
          profileImageUrl: userData['profileImageUrl'] ?? '',
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateUserProfile(ProfileUser updatedProfile) async {
    try {
      //convert to json
      await firebaseFirestore
          .collection('users')
          .doc(updatedProfile.uid)
          .update({
            'bio': updatedProfile.bio,
            'profileImageUrl': updatedProfile.profileImageUrl,
          });
    } catch (e) {
      throw Exception(e);
    }
  }
}
