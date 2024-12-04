import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/features/post/data/repository/post_repository.dart';
import 'package:social_app/features/post/domain/entities/post.dart';

class FirebasePostRepository implements PostRepository {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');
  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception('Error creating post:$e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      final postsSnapshot =
          await postsCollection.orderBy('timestamp', descending: true).get();

      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      
      return allPosts;
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      final postsSnapshot =
          await postsCollection.where('userId', isEqualTo: userId).get();
      final userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return userPosts;
    } catch (e) {
      throw Exception('Error fetching posts by user: $e');
    }
  }
}
