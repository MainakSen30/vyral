import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
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
  //mobile image picker
  PlatformFile? imagePickedFile;
  //web image picker
  Uint8List? webImage;
  //text controller for bio
  final bioTextController = TextEditingController();
  //pick Image method
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  //update profile
  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();
    //prepare images
    final String uid = widget.user.uid;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;
    final String? newBio = bioTextController.text.isNotEmpty
        ? bioTextController.text
        : null;

    //update profile if there are things to update.
    if (newBio != null || imageMobilePath != null || imageWebBytes != null) {
      profileCubit.updateProfile(
        uid: uid,
        newBio: newBio,
        newProfilePicmobile: imageMobilePath,
        newProfilePicWeb: imageWebBytes,
      );
    } else {
      Navigator.pop(context);
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

  Widget buildEditPage() {
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
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Text(
                  'profile picture',
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
          //profile picture
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.hardEdge,
              //display selected image for mobile.
              child:
              (!kIsWeb && imagePickedFile != null)
              ?
              Image.file(
                File(imagePickedFile!.path!),
                fit: BoxFit.cover,
              )
              :
              //display selected image for web.
              (kIsWeb && webImage!= null)
              ?
              Image.memory(
                webImage!,
                fit: BoxFit.cover,
              )
              :
              //if no image selected, display default image.
              CachedNetworkImage(
                imageUrl: widget.user.profileImageUrl,
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
                  Image(image: imageProvider),
              ),
            ),
          ),
          SizedBox(height: 10,),
          //pick image button
          Center(
            child: MaterialButton(
              color: Theme.of(context).colorScheme.secondary,
              onPressed: pickImage,
              elevation: 0.0, // Remove shadow
              highlightElevation: 0.0, // Remove shadow on press
              hoverElevation: 0.0, // Remove shadow on hover
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              
              child: Text(
                'change profile picture',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
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
