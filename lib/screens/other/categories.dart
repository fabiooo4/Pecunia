import 'package:flutter/material.dart';
import 'package:pecunia/widgets/menu_tile.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Categories'),
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
