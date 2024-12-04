import 'package:social_app/features/post/domain/entities/post.dart';

abstract class PostStates {}

class PostsInitial extends PostStates {}

class PostsLoading extends PostStates {}

class PostsUploading extends PostStates {}

class PostsError extends PostStates {
  final String message;

  PostsError(this.message);
}

class PostsLoaded extends PostStates {
  final List<Post> posts;

  PostsLoaded(this.posts);
}
