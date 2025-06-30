/*
register page will faccilitate the registration of new pwoplw to the app.
will mostly have the same functionalities as the login page, witb differences in parameters
that is the inclusion of a username that should be done by the user.
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/components/my_button.dart';
import 'package:social_media_app/features/authentication/presentation/components/my_text_field.dart';
import 'package:social_media_app/features/authentication/presentation/cubits/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //all the required controllers for managing the texts in the text fields.
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //register button functionality.
  void register() {
    //prepare the data.
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;
    //auth cubit.
    final authCubit = context.read<AuthCubit>();
    //ensure that the fields aren't empty.
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      //ensure that the passwords match.
      if (password == confirmPassword) {
        authCubit.register(name, email, password);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Passwords do not match.',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all the fields before submitting.',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 14,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    //dispose the controllers to avoid memory leaks.
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                  "Create your account now!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Poppins',
                  ),
                ),
                //text fields for email and password
                SizedBox(height: 20),
                //name text field.
                MyTextField(
                  controller: nameController,
                  hintText: "name",
                  obscureText: false,
                  minimumLines: 1,
                  maximumLines: 1,
                ),
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                //confirm password text field.
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  minimumLines: 1,
                  maximumLines: 1,
                ),
                //register button
                SizedBox(height: 10),
                MyButton(onTap: register, text: 'Register'),
                //redirect to the login page.
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member? ',
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
                        'Login now',
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
