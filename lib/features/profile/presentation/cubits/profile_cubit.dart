//cubits for the profile user. compare this snippet from profile_cubit.dart:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/domain/repository/profile_repo.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;
  ProfileCubit({required this.profileRepo}) : super(ProfileInitialState());
  //fetch user details
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoadingState());
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

  //update user bio and profile picture
  Future<void> updateProfile({required String uid, String? newBio}) async {
    try {
      emit(ProfileLoadingState());
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileErrorState('cannot find user'));
        return;
      }
      //profile picture update
      //updated profile user
      final updatedUser = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
      );
      await profileRepo.updateUserProfile(updatedUser);
      //refetch updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileErrorState('Error updating profile $e'));
    }
  }
}
