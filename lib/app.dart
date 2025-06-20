/*
  This class is the root of the application.
  It is responsible for creating the theme and the home page.
  Repositories for the database - firebase
  Bloc providers for the state management
   - auth
   - profile
   - posts
   - search
   - themes
  check auth state
  if auth state is authenticated, show home page
  if auth state is not authenticated, show auth page
  if auth state is unknown, show loading page
  if auth state is error, show error page
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/Themes/light_mode.dart';
import 'package:social_media_app/features/authentication/data/firebase_auth_repo.dart';
import 'package:social_media_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/authentication/presentation/cubits/auth_states.dart';
import 'package:social_media_app/features/authentication/presentation/pages/auth_page.dart';
import 'package:social_media_app/features/home/presentation/pages/home_page.dart';
import 'package:social_media_app/features/profile/data/repository/firebase_profile_repo.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_cubit.dart';

class MyApp extends StatelessWidget {
  //initialize auth repo
  final authRepo = FireBaseAuthRepo();
  //initialize profile repo
  final profileRepo = FirebaseProfileRepo();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //authcubit
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
        ),
        //profilecubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(profileRepo: profileRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            if (authState is Unauthenticated) {
              return const AuthPage();
            } else if (authState is Authenticated) {
              return const HomePage();
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
          //this listener will listen for any errors.
          listener: (context, authState) {
            if (authState is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(authState.message)));
            }
          },
        ),
      ),
    );
  }
}
