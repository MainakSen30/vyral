import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/posts/domain/entities/post.dart';
import 'package:social_media_app/features/posts/domain/repository/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  //firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //store posts in a collection by the name post
  final CollectionReference postsCollection = FirebaseFirestore.instance
      .collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      //fetch all posts with the most recent ones at the top.
      final postSnapshot = await postsCollection
          .orderBy('timeStamp', descending: true)
          .get();
      //convert each firestore document from json to list of posts.
      final List<Post> allPosts = postSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allPosts;
    } catch (e) {
      throw Exception("Failed to fetch posts: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostsById(String userId) async {
    try {
      //fetch all posts with this given userId.
      final postSnapshots = await postsCollection
          .where('userid', isEqualTo: userId)
          .get();
      //map the firestore documents from json to lists of posts.
      final userPosts = postSnapshots.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return userPosts;
    } catch (e) {
      throw Exception("Failed to fetch posts: $e");
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      final postDocument = await postsCollection.doc(postId).get();
      if (postDocument.exists) {
        final post = Post.fromJson(postDocument.data() as Map<String, dynamic>);
        //check if user has already liked the post.
        final hasLiked = post.likes.contains(userId);
        //update likes list.
        if (hasLiked) {
          post.likes.remove(userId);
        } else {
          post.likes.add(userId);
        }
        //update the post document with the likes
        await postsCollection.doc(postId).update({'likes': post.likes});
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error liking post : $e try again later");
    }
  }
}
