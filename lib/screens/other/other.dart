import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../api/sign_in/signin_repository.dart';
import '../../widgets/navigation_bar.dart';
import '../../widgets/menu_tile.dart';

class Other extends ConsumerStatefulWidget {
  const Other({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtherState();
}

class _OtherState extends ConsumerState<Other> {
  @override
  Widget build(BuildContext context) {
    final username = Supabase.instance.client.auth.currentUser
            ?.userMetadata!['username'] as String? ??
        'User';

    final email = Supabase.instance.client.auth.currentUser?.email ?? 'Email';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFF072E08),
                      child: Text(
                        username.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.w900,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ),

                    //? Edit Profile Button
                    // Transform(
                    //   transform: Matrix4.translationValues(35, -36, 0),
                    //   child: CircleAvatar(
                    //     radius: 18,
                    //     backgroundColor: Colors.lightGreen,
                    //     child: IconButton(
                    //       icon: const Icon(
                    //         Icons.edit,
                    //         color: Color(0xFF072E08),
                    //         size: 19,
                    //       ),
                    //       onPressed: () {},
                    //     ),
                    //   ),
                    // ),

                    Column(
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                              fontSize: 45, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                      ),
                      onPressed: () {},
                      child: const Text('Edit Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Divider(
                            color: Colors.black12,
                          ),
                          const SizedBox(height: 20),
                          MenuTileWidget(
                            leadingIcon: Icons.settings,
                            title: const Text('Settings'),
                            onTap: () {
                              context.go('/other/settings');
                            },
                          ),
                          MenuTileWidget(
                            leadingIcon: Icons.category,
                            title: const Text('Categories'),
                            onTap: () {},
                          ),
                          MenuTileWidget(
                            leadingIcon: Icons.account_balance_wallet,
                            title: const Text('Accounts'),
                            onTap: () {},
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            color: Colors.black12,
                          ),
                          const SizedBox(height: 10),
                          MenuTileWidget(
                            leadingIcon: Icons.logout,
                            title: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                            onTap: () async {
                              await ref
                                  .read(signInRepositoryProvider)
                                  .signOut()
                                  .then(
                                    (value) => {
                                      context.go('/'),
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Logged out succesfully!"),
                                          backgroundColor: Colors.red,
                                        ),
                                      )
                                    },
                                  );
                            },
                            endIcon: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(active: 2),
    );
  }
}
