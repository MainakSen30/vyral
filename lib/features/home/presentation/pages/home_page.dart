/*
this is the home page of the application having all the posts.
*/
import 'package:flutter/material.dart';
import 'package:social_media_app/features/home/presentation/components/app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      //drawer
      drawer: AppDrawer(),
    );
  }
}
