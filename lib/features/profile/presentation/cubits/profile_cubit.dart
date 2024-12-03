import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/profile/data/repository/profile_repository.dart';
import 'package:social_app/features/profile/presentation/cubits/profile_states.dart';
import 'package:social_app/features/storage/data/firebase_storage_repository.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepository profileRepository;
  final FirebaseStorageRepository firebaseStorageRepository;

  ProfileCubit({
    required this.profileRepository,
    required this.firebaseStorageRepository,
  }) : super(
          ProfileIntitial(),
        );
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepository.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(
          ProfileError('User not found'),
        );
      }
    } catch (e) {
      ProfileError(
        e.toString(),
      );
    }
  }

  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());
    try {
      final currentUser = await profileRepository.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(
          ProfileError('Failed to fetch user for profile update'),
        );
        return;
      }
      String? imageDownloadUrl;
      if (imageWebBytes != null || imageMobilePath != null) {
        if (imageMobilePath != null) {
          imageDownloadUrl =
              await firebaseStorageRepository.uploadProfileImageMobile(
            imageMobilePath,
            uid,
          );
        } else if (imageWebBytes != null) {
          imageDownloadUrl = await firebaseStorageRepository
              .uploadProfileImageWeb(imageWebBytes, uid);
        }
        if (imageDownloadUrl == null) {
          emit(
            ProfileError('Failed to upload image'),
          );
          return;
        }
      }
      final updateProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );
      await profileRepository.updateProfile(updateProfile);
      await fetchUserProfile(uid);
    } catch (e) {
      emit(
        ProfileError(
          'Error updating profile: $e',
        ),
      );
    }
  }
}
