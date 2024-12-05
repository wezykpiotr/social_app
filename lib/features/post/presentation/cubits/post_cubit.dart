import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/post/data/repository/post_repository.dart';
import 'package:social_app/features/post/domain/entities/post.dart';
import 'package:social_app/features/post/presentation/cubits/post_states.dart';
import 'package:social_app/features/storage/data/storage_repository.dart';

class PostCubit extends Cubit<PostStates> {
  final PostRepository postRepository;
  final StorageRepository storageRepository;

  PostCubit({
    required this.postRepository,
    required this.storageRepository,
  }) : super(PostsInitial());

  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;

    try {
      if (imagePath != null) {
        emit(PostsUploading());
        imageUrl =
            await storageRepository.uploadPostImageMobile(imagePath, post.id);
      } else if (imageBytes != null) {
        emit(PostsUploading());
        imageUrl =
            await storageRepository.uploadPostImageWeb(imageBytes, post.id);
      }

      final newPost = post.copyWith(imageUrl: imageUrl);
      postRepository.createPost(newPost);
      fetchAllPosts();
    } catch (e) {
      emit(
        PostsError('Failed to create post: $e'),
      );
    }
  }

  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepository.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(
        PostsError('Failed to fetch posts: $e'),
      );
    }
  }

  Future<void> deletePost(String postId) async {
    await postRepository.deletePost(postId);
  }

  Future<void> toggleLikesPost(String postId, String userId) async {
    try {
      await postRepository.toggleLikesPost(postId, userId);
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }
}
