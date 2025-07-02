//cubits for the profile user. compare this snippet from profile_cubit.dart:
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/domain/repository/profile_repo.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_states.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;
  ProfileCubit({required this.profileRepo, required this.storageRepo})
    : super(ProfileInitialState());

  Future<void> fetchUserProfile() async {
    emit(ProfileLoadingState());
    try {
      final user = await profileRepo.fetchUserProfile();
      if (user != null) {
        emit(ProfileLoadedState(user));
      } else {
        emit(ProfileErrorState('User not found'));
      }
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
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
      final currentUser = await profileRepo.fetchUserProfile();
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
        newProfileImageUrl: imagedownloadUrl ??currentUser.profileImageUrl,
      );
      await profileRepo.updateUserProfile(updatedUser);
      //refetch updated profile
      await fetchUserProfile();
    } catch (e) {
      emit(ProfileErrorState('Error updating profile $e'));
    }
  }
}
