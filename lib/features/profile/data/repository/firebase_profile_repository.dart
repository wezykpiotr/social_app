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
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);
          return ProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
            followers: followers,
            following: following,
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

  @override
  Future<void> toggleFollow(String currentUserId, targetUserId) async {
    try {
      final currentUserDoc =
          await firebaseFirestore.collection('user').doc(currentUserId).get();
      final targetUserDoc =
          await firebaseFirestore.collection('users').doc(targetUserId).get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();
        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing =
              List<String>.from(currentUserData['following'] ?? []);
          if (currentFollowing.contains(targetUserId)) {
            await firebaseFirestore
                .collection('users')
                .doc(currentUserId)
                .update({
              'following': FieldValue.arrayRemove([targetUserId]),
            });
            await firebaseFirestore
                .collection('users')
                .doc(targetUserId)
                .update({
              'followers': FieldValue.arrayRemove([currentUserId])
            });
          } else {
            await firebaseFirestore
                .collection('users')
                .doc(currentUserId)
                .update({
              'following': FieldValue.arrayUnion([targetUserId]),
            });
            await firebaseFirestore
                .collection('users')
                .doc(targetUserId)
                .update({
              'followers': FieldValue.arrayUnion([currentUserId])
            });
          }
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
