// this is going to be used multiple times to make the drawer functional
//with all the tiles present in it.
import 'package:flutter/material.dart';

class AppDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;
  const AppDrawerTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      leading: Icon(
        icon,
        size: 30,
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      onTap: onTap,
    );
  }
}
