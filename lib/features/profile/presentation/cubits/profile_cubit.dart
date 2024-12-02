import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/profile/data/repository/profile_repository.dart';
import 'package:social_app/features/profile/presentation/cubits/profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepository profileRepository;

  ProfileCubit({required this.profileRepository})
      : super(
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

  Future<void> updateProfile({required String uid, String? newBio}) async {
    emit(ProfileLoading());
    try {
      final currentUser = await profileRepository.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(
          ProfileError('Failed to fetch user for profile update'),
        );
        return;
      }
      final updateProfile =
          currentUser.copyWith(newBio: newBio ?? currentUser.bio);
      await profileRepository.updateProfile(updateProfile);
      await fetchUserProfile(uid);
    } catch (e) {
      emit(
        ProfileError(
          'Error updating profile: ' + e.toString(),
        ),
      );
    }
  }
}
