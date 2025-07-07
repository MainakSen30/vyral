/*
this is the home page of the application having all the posts.
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/home/presentation/components/app_drawer.dart';
import 'package:social_media_app/features/home/presentation/components/post_tile.dart';
import 'package:social_media_app/features/posts/presentation/cubits/post_cubits.dart';
import 'package:social_media_app/features/posts/presentation/cubits/post_states.dart';
import 'package:social_media_app/features/posts/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //post cubit
  late final postCubit = context.read<PostCubits>();
  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

  //fetch all the posts.
  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  //delete Post
  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Home',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadPostPage()),
            ),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      //drawer
      drawer: AppDrawer(),
      body: BlocBuilder<PostCubits, PostStates>(
        builder: (context, state) {
          //laoding
          if (state is PostLoadingState && state is PostUploadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }
          //loaded
          else if (state is PostLoadedState) {
            final allPosts = state.posts;
            if (allPosts.isEmpty) {
              return Center(
                child: Text(
                  'No posts yet!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                //get individual post
                final post = allPosts[index];
                //return image
                return PostTile(
                  post: post,
                  onPressedDelete: () => deletePost(post.id),
                );
              },
            );
          }
          //error
          else if (state is PostErrorState) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),

      //build the body
    );
  }
}
