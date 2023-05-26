import 'package:flutter/material.dart';
import 'package:pecunia/widgets/menu_tile.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MenuTileWidget(
              leadingIcon: Icons.dark_mode,
              title: const Text('Dark Mode'),
              onTap: () {})
        ],
      ),
    );
  }
}
