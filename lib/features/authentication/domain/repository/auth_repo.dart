/*
outlines the possible operaations for this app,
*/
import 'package:social_media_app/features/authentication/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  );
  Future<void> logOut();
  Future<AppUser?> getCurrentUser();
}
