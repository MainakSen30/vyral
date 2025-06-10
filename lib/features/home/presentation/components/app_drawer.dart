//drawer for the app
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/home/presentation/components/app_drawer_tile.dart';
import 'package:social_media_app/features/profile/presentation/pages/profile_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              //divider line
              Divider(color: Theme.of(context).colorScheme.secondary),
              //home tile
              AppDrawerTile(
                title: "H O M E",
                icon: Icons.home,
                onTap: () => Navigator.of(context).pop(),
              ),
              //profile tile
              AppDrawerTile(
                title: "P R O F I L E",
                icon: Icons.person_2,
                onTap: () {
                  Navigator.of(context).pop();
                  //get current user id
                  final user = context.read<AuthCubit>().currentUser;
                  String? uid = user!.uid;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage(uid: uid,)),
                  );
                },
              ),
              //search tile
              AppDrawerTile(
                title: "S E A R C H",
                icon: Icons.search,
                onTap: () {},
              ),
              //settings tile
              AppDrawerTile(
                title: "S E T T I N G S",
                icon: Icons.settings,
                onTap: () {},
              ),
              //for putting tyhe logout button at the very bottom of the drawer.
              const Spacer(),
              //logout tile
              AppDrawerTile(
                title: "L O G O U T",
                icon: Icons.logout,
                onTap: () => context.read<AuthCubit>().logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
