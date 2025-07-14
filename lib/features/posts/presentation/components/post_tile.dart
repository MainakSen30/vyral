import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/authentication/domain/entities/app_user.dart';
import 'package:social_media_app/features/authentication/presentation/components/my_text_field.dart';
import 'package:social_media_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/posts/domain/entities/comment.dart';
import 'package:social_media_app/features/posts/domain/entities/post.dart';
import 'package:social_media_app/features/posts/presentation/cubits/post_cubits.dart';
import 'package:social_media_app/features/posts/presentation/cubits/post_states.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_cubit.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onPressedDelete;
  const PostTile({
    super.key,
    required this.post,
    required this.onPressedDelete,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  //show options for deletion
  late final postCubit = context.read<PostCubits>();
  late final profileCubit = context.read<ProfileCubit>();
  bool isOwnPost = false;

  //current user
  AppUser? currentUser;
  //profile user
  ProfileUser? postUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  //toggle like on post
  void toggleLikePost() {
    //update the likes in the Post,
    final isLiked = widget.post.likes.contains(currentUser!.uid);
    //optimistically like and update the ui
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });
    postCubit.toggleLikePost(widget.post.id, currentUser!.uid).catchError((
      error,
    ) {
      //if there is an error, revert back to the old values.
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  //commments
  //comment text controller
  final commentTextController = TextEditingController();
  //open a comment box
  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: MyTextField(
          controller: commentTextController,
          hintText: "add a new comment...",
          obscureText: false,
          minimumLines: 1,
          maximumLines: 5,
        ),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          //save button
          TextButton(
            onPressed: () {
              addComment();
              Navigator.of(context).pop();
            },
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addComment() {
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: widget.post.userId,
      userName: widget.post.userName,
      text: commentTextController.text,
      timeStamp: DateTime.now(),
    );
    //add comment using cubit
    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Do you want to delete this post?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        actions: [
          //cancel button
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          //confirm button
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              widget.onPressedDelete!();
              Navigator.of(context).pop();
            },
            child: Text(
              'Confirm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          //top section profile / name / delete button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                postUser?.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : const Icon(Icons.person),
                const SizedBox(width: 10),
                Text(
                  widget.post.userName,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const Spacer(),
                //delete button
                if (isOwnPost)
                  GestureDetector(
                    onTap: showOptions,
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),

          //image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => SizedBox(height: 430),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          //likes, comments, datetime of posting
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                //likes
                GestureDetector(
                  onTap: toggleLikePost,
                  child: Icon(
                    Icons.favorite,
                    color: widget.post.likes.contains(currentUser!.uid)
                        ? Colors.red
                        : Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  widget.post.likes.length.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(width: 15),
                //comment
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(Icons.comment_outlined),
                ),
                const SizedBox(width: 5),
                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const Spacer(),
                //date time
                Text(
                  widget.post.timeStamp.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          //caption
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                postUser?.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : const Icon(Icons.person),
                const SizedBox(width: 10),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    children: [
                      TextSpan(
                        text: widget.post.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      TextSpan(
                        text: ' : ${widget.post.text}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Theme.of(context).colorScheme.primary),
          //comments
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: BlocBuilder<PostCubits, PostStates>(
              builder: (context, state) {
                //post loaded state.
                if (state is PostLoadedState) {
                  //final individual post
                  final post = state.posts.firstWhere(
                    (post) => post.id == widget.post.id,
                  );
                  if (post.comments.isNotEmpty) {
                    int showCommentCount = post.comments.length;
                    //comment section
                    return ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 7),
                      itemCount: showCommentCount,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final comment = post.comments[index];
                        //comment tile ui
                        return Row(
                          children: [
                            postUser?.profileImageUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: postUser!.profileImageUrl,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.person),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                  )
                                : const Icon(Icons.person),
                            const SizedBox(width: 5),
                            Text(
                              comment.userName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              ': ${comment.text}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
                //post loading state
                if (state is PostLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PostErrorState) {
                  return Center(child: Text(state.message));
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
