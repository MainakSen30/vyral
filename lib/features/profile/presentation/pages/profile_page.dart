//This is the profile page of the user who is logged in to the account.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/authentication/domain/entities/app_user.dart';
import 'package:social_media_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/profile/presentation/components/bio_box.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_states.dart';
import 'package:social_media_app/features/profile/presentation/pages/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  //current user
  late AppUser? currentUser = authCubit.currentUser;
  //on startup
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        //loaded
        if (state is ProfileLoadedState) {
          //get user
          final user = state.profileUser;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                user.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              foregroundColor: Theme.of(context).colorScheme.primary,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () => Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context) => EditProfilePage(user: user,),
                      )
                    ),
                  icon: Icon(Icons.edit),
                ),
              ],
            ),
            body: Column(
              children: [
                //email
                Text(
                  user.email,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 25.0),
                //profile picture
                CachedNetworkImage(
                imageUrl: user.profileImageUrl,
                //loading
                placeholder: (context, url) => 
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
                //error
                errorWidget: (context, url, error) => 
                  Icon(
                    Icons.person_2_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 72,
                  ),
                //loaded
                imageBuilder: (context, imageProvider) => 
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ),
                SizedBox(height: 25),
                //bio
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Text(
                        'bio',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                BioBox(text: user.bio),
                //posts
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 12),
                  child: Row(
                    children: [
                      Text(
                        'posts',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        //loading..
        else if (state is ProfileLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Center(
            child: Text(
              "No Profile found..",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(20, 158, 158, 158),
              ),
            ),
          );
        }
      },
    );
  }
}
