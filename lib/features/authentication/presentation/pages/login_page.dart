/*
On this page, an existing user can login using their email adn password,
after which they will be redirected to the home page.
OR,
A new user can register using their name, email and password, after which they
will be redirected to the home page of the app.
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/components/my_button.dart';
import 'package:social_media_app/features/authentication/presentation/components/my_text_field.dart';
import 'package:social_media_app/features/authentication/presentation/cubits/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controllers for managing the text in the text fields.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //login method
  void login() {
    final String email = emailController.text;
    final String password = passwordController.text;
    //auth cubit
    final authCubit = context.read<AuthCubit>();
    //ensure that the email and password fields are not empty.
    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    } else {
      //show an error message if any of the fields are empty.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Please fill in all the fields before submitting.',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 14,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        )
      ));
    }
  }

  @override
  void dispose() {
    //dispose the controllers to avoid memory leaks.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Icon(
                  Icons.lock_open_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 50),
                //welcome message
                Text(
                  "Welcome back, pick up from where you left!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Poppins',
                  ),
                ),
                //text fields for email and password
                SizedBox(height: 20),
                //email text field.
                MyTextField(
                  controller: emailController,
                  hintText: "email",
                  obscureText: false,
                  minimumLines: 1,
                  maximumLines: 1,
                ),
                SizedBox(height: 10),
                //password text field.
                MyTextField(
                  controller: passwordController,
                  hintText: "password",
                  obscureText: true,
                  minimumLines: 1,
                  maximumLines: 1,
                ),
                //login button
                SizedBox(height: 10),
                MyButton(onTap: login, text: 'login'),
                //redirect to the register page.
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member? ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        'Register now',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(
                            context,
                          ).colorScheme.inversePrimary,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
