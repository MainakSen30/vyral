import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/authentication/domain/entities/app_user.dart';
import 'package:social_media_app/features/authentication/presentation/components/my_text_field.dart';
import 'package:social_media_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/posts/domain/entities/post.dart';
import 'package:social_media_app/features/posts/presentation/cubits/post_cubits.dart';
import 'package:social_media_app/features/posts/presentation/cubits/post_states.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  //mobile image picker.
  PlatformFile? imagePickedFile;
  //web image
  Uint8List? webImage;
  //text controller for caption.
  final captionTextController = TextEditingController();
  //trach the current User.
  AppUser? currentUser;

  //get the current user
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  //pick image
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

  //create and upload post
  void uploadPost() {
    //check if both image and caption are provided.
    if (imagePickedFile == null || captionTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Both image and caption are needed")),
      );
      return;
    }
    //create a new post object.
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: captionTextController.text,
      imageUrl: '',
      timeStamp: DateTime.now(),
      likes: [],
      comments: [],
    );
    //upload the post.
    final postCubit = context.read<PostCubits>();
    //web upload.
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    }
    //mobile upload.
    else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  //dispose the controller
  @override
  void dispose() {
    captionTextController.dispose();
    super.dispose();
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubits, PostStates>(
      builder: (context, state) {
        if (state is PostLoadingState || state is PostUploadingState) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Uploading post',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return buildUploadPage();
      },
      //go to previous page when post is uploaded
      listener: (context, state) {
        if (state is PostLoadedState) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Post',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        foregroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        actions: [
          //upload button
          IconButton(
            onPressed: uploadPost, 
            icon: Icon(Icons.upload)
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            //web
            if (kIsWeb && webImage != null) Image.memory(webImage!),
            //mobile
            if (!kIsWeb && imagePickedFile != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  height: 430,
                  child: Image.file(
                    File(imagePickedFile!.path!), 
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            MaterialButton(
              color: Theme.of(context).colorScheme.secondary,
              onPressed: pickImage,
              elevation: 0.0, // Remove shadow
              highlightElevation: 0.0, // Remove shadow on press
              hoverElevation: 0.0, // Remove shadow on hover
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: Text(
                'pick image',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            //caption text controller
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: MyTextField(
                controller: captionTextController,
                hintText: "caption",
                obscureText: false,
                minimumLines: 1,
                maximumLines: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
