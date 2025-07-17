import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:social_media_app/features/posts/domain/entities/post.dart';

class PostGridTile extends StatelessWidget {
  final List<Post> userPosts;
  final int postCount;

  const PostGridTile({
    super.key,
    required this.userPosts,
    required this.postCount,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: postCount,
      itemBuilder: (context, index) {
        final post = userPosts[index];
        return CachedNetworkImage(
          imageUrl: post.imageUrl,
          //loading
          placeholder: (context, url) => CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          //error
          errorWidget: (context, url, error) =>
              Icon(Icons.error, color: Theme.of(context).colorScheme.primary),
          //loaded
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}
