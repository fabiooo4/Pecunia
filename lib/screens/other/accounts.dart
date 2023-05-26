import 'package:flutter/material.dart';
import 'package:pecunia/widgets/menu_tile.dart';

class Accounts extends StatelessWidget {
  const Accounts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Accounts'),
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
