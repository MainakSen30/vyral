import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/authentication/domain/entities/app_user.dart';
import 'package:social_media_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/posts/domain/entities/comment.dart';
import 'package:social_media_app/features/posts/presentation/cubits/post_cubits.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/presentation/pages/profile_page.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  final ProfileUser? postUser;
  const CommentTile({required this.comment, this.postUser, super.key});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  //get the current user
  AppUser? currentUser;
  bool isOwnPost = false;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.comment.userId == currentUser?.uid);
  }

  //show options for deleting
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Do you want to delete this comment?',
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
              context.read<PostCubits>().deleteComment(
                widget.comment.postId, widget.comment.id
              );
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
    return Row(
      children: [
        widget.postUser?.profileImageUrl != null
            ? GestureDetector(
              onTap: () => Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    uid: currentUser!.uid
                    )
                  )
                ),
              child: CachedNetworkImage(
                  imageUrl: widget.postUser!.profileImageUrl,
                  errorWidget: (context, url, error) => const Icon(Icons.person),
                  imageBuilder: (context, imageProvider) => Container(
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
                ),
            )
            : const Icon(Icons.person),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () => Navigator.push(
            context, MaterialPageRoute(
              builder: (context) => ProfilePage(
                uid: currentUser!.uid
                )
              )
            ),
          child: Text(
            widget.comment.userName,
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
          ),
        ),
        Text(
          ': ${widget.comment.text}',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        //delete button
        const Spacer(),
        if (isOwnPost)
          GestureDetector(
            onTap: showOptions,
            child: Icon(
              Icons.more_horiz_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 16,
            ),
          )
      ],
    );
  }
}
