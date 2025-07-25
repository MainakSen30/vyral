import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/posts/domain/entities/comment.dart';
import 'package:social_media_app/features/posts/domain/entities/post.dart';
import 'package:social_media_app/features/posts/domain/repository/post_repo.dart';
import 'package:social_media_app/features/posts/presentation/cubits/post_states.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class PostCubits extends Cubit<PostStates> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;
  PostCubits({required this.postRepo, required this.storageRepo})
    : super(PostInitialState());
  //create a new post
  Future<void> createPost(
    Post post, {
    String? imagePath,
    Uint8List? imageBytes,
  }) async {
    String? imageUrl;
    //handle image from mobile.
    try {
      if (imagePath != null) {
        emit(PostUploadingState());
        imageUrl = await storageRepo.uploadPostImageOnMobile(
          imagePath,
          post.id,
        );
      }
      //handle image from web
      else if (imageBytes != null) {
        emit(PostUploadingState());
        imageUrl = await storageRepo.uploadPostImageOnWeb(imageBytes, post.id);
      }
      //create the post
      final newPost = post.copyWith(imageUrl: imageUrl);
      postRepo.createPost(newPost);
      // re fetch all posts.
      fetchAllPosts();
    } catch (e) {
      emit(PostErrorState("Failed to create post: $e"));
    }
  }

  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoadingState());
      final posts = await postRepo.fetchAllPosts();
      emit(PostLoadedState(posts));
    } catch (e) {
      emit(PostErrorState("Failed to load posts: $e"));
    }
  }

  //delete post
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      emit(PostErrorState("Failed to delete post: $e"));
    }
  }

  //toggle like on post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostErrorState("Failed to like the post : $e try again later"));
    }
  }

  //write comments on the post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostErrorState("Couldn't add comment : $e try again later"));
    }
  }

  //delete comments from post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostErrorState("Couldn't delete comment : $e try again later"));
    }
  }
}
