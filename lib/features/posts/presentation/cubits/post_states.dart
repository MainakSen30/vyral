//different post states
import 'package:social_media_app/features/posts/domain/entities/post.dart';

abstract class PostStates {}

//initial state
class PostInitialState extends PostStates {}

//loading state
class PostLoadingState extends PostStates {}

//uploading state
class PostUploadingState extends PostStates {}

//error state
class PostErrorState extends PostStates {
  final String message;
  PostErrorState(this.message);
}

//loaded state
class PostLoadedState extends PostStates {
  final List<Post> posts;
  PostLoadedState(this.posts);
}
