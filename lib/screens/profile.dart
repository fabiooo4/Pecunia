import 'package:flutter/material.dart';
import 'package:pecunia/widgets/navigation_bar.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Profile'),
      ),
      bottomNavigationBar: const NavBar(active: 2),
    );
  }
}
