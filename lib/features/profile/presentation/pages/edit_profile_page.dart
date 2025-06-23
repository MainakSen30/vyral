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
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        //profile loading
        //profile error
        //profile loaded
        return buildEditPage();
      },
      listener: (context, state) {},
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
          SizedBox(height: 10,),
          //bio text field
          Padding(
            padding: const EdgeInsets.all(12),
            child: MyTextField(
              controller: bioTextController, 
              hintText: widget.user.bio, 
              obscureText: false
            ),
          ),
            
          SizedBox(height: 10,),
        ],
      )
    );
  }
}
