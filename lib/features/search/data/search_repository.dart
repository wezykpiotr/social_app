import 'package:social_app/features/profile/domain/entities/profile_user.dart';

abstract class SearchRepository {
  Future<List<ProfileUser?>> searchUsers(String query);
}
