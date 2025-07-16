import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/features/posts/domain/entities/comment.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  final ProfileUser? postUser;
  const CommentTile({
    required this.comment,
    this.postUser,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        postUser?.profileImageUrl != null
            ? CachedNetworkImage(
                imageUrl: postUser!.profileImageUrl,
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
              )
            : const Icon(Icons.person),
        const SizedBox(width: 5),
        Text(
          comment.userName,
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
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
  }
}
