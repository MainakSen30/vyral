//auth states

import 'package:social_media_app/features/authentication/domain/entities/app_user.dart';

abstract class AuthState {
  get user => null;

}
//initial state
class AuthInitial extends AuthState {
  
}
//loading state
class AuthLoading extends AuthState {

}
//authenticated
class Authenticated extends AuthState {
  final AppUser user;
  Authenticated(this.user);

}
//unauthenticated
class Unauthenticated extends AuthState {
  
}
//errors
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}