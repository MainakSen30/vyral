/*
Auth page happens to help in managing the login and registration of users,
and redirecting them to the main page of the app displaying all the content
that is available to the user.
*/
import 'package:flutter/material.dart';
import 'package:social_media_app/features/authentication/presentation/pages/login_page.dart';
import 'package:social_media_app/features/authentication/presentation/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //initially show the login page.
  bool showLoginPage = true;
  //toggle between the login page and the register page.
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  //if the user is already a member, redirect them to the login page.
  //if the user is not a member, redirect them to the register page.
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        togglePages: togglePages,
      );
    } else {
      return RegisterPage(
        togglePages: togglePages,
      );
    }
  }
}
