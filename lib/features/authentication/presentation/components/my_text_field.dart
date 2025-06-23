//managing the text fields because it iṡ going to be reused in the logion and register page.
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: 1,
      maxLines: 4,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        //unselected border of the text field.
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        //selected border of the text field.
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        //hint text fior each text field.
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary
        ),
        fillColor: Theme.of(context).colorScheme.tertiary,
        filled: true,
      ),
    );
  }
}
