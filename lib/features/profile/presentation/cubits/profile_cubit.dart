//cubits for the profile user. compare this snippet from profile_cubit.dart:
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/domain/repository/profile_repo.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_states.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;
  ProfileCubit({required this.profileRepo, required this.storageRepo})
    : super(ProfileInitialState());

  Future<void> fetchUserProfile(String uid) async {
    emit(ProfileLoadingState());
    try {
      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoadedState(user));
      } else {
        emit(ProfileErrorState('User not found'));
      }
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }

  //fetch user profile with a given Uid which is useful for loading posts from many profiles
  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);
    return user;
  }

  //update user bio and profile picture
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? newProfilePicWeb,
    String? newProfilePicmobile,
  }) async {
    emit(ProfileLoadingState());
    try {
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileErrorState('cannot find user'));
        return;
      }
      //profile picture update
      String? imagedownloadUrl;
      //ensure there is an image
      if (newProfilePicWeb != null || newProfilePicmobile != null) {
        //for mobile
        if (newProfilePicmobile != null) {
          imagedownloadUrl = await storageRepo.uploadProfileImageOnMobile(
            newProfilePicmobile,
            uid,
          );
        }
        //for web
        else if (newProfilePicWeb != null) {
          imagedownloadUrl = await storageRepo.uploadProfileImageOnWeb(
            newProfilePicWeb,
            uid,
          );
        }
        //error state
        if (imagedownloadUrl == null) {
          emit(ProfileErrorState("Failed to upload image"));
          return;
        }
      }
      //updated profile user
      final updatedUser = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imagedownloadUrl ?? currentUser.profileImageUrl,
      );
      await profileRepo.updateUserProfile(updatedUser);
      //refetch updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileErrorState('Error updating profile $e'));
    }
  }
}
