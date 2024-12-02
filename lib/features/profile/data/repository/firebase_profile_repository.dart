import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/features/profile/data/repository/profile_repository.dart';
import 'package:social_app/features/profile/domain/entities/profile_user.dart';

class FirebaseProfileRepository implements ProfileRepository {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {

          return ProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ??'',
            profileImageUrl: userData['profileImageUrl'].toString(),
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updateProfile) async {
    try {
      await firebaseFirestore.collection('users').doc(updateProfile.uid).update(
        {
          'bio': updateProfile.bio,
          'profileImageUrl': updateProfile.profileImageUrl,
        },
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
