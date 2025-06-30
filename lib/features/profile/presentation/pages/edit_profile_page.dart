import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/components/my_text_field.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioTextController = TextEditingController();
  //update profile
  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();
    if (bioTextController.text.isNotEmpty) {
      profileCubit.updateProfile(
        uid: widget.user.uid,
        newBio: bioTextController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        //profile loading
        if (state is ProfileLoadingState) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Uploading profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        //profile loaded
        return buildEditPage();
      },
      listener: (context, state) {
        if (state is ProfileLoadedState) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditPage({double uploadProgress = 0.0}) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        foregroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        actions: [
          IconButton(onPressed: updateProfile, icon: const Icon(Icons.upload)),
        ],
      ),
      body: Column(
        children: [
          //profile picture
          //bio text
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
          SizedBox(height: 10),
          //bio text field
          Padding(
            padding: const EdgeInsets.all(12),
            child: MyTextField(
              controller: bioTextController,
              hintText: widget.user.bio,
              obscureText: false,
              minimumLines: 1,
              maximumLines: 4,
            ),
          ),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}
