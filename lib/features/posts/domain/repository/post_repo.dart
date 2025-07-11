import 'package:social_media_app/features/posts/domain/entities/post.dart';

abstract class PostRepo {
  Future<List<Post>> fetchAllPosts();
  Future<void> createPost(Post post);
  Future<void> deletePost(String postId);
  Future<List<Post>> fetchPostsById(String userId);
  Future<void> toggleLikePost(String postId, String userId);
}
