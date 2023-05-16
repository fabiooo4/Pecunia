import 'package:flutter/material.dart';

class ProviderTile extends StatelessWidget {
  final String path;

  const ProviderTile({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      onTap: () {
        path == 'assets/images/google.png' ? print('google') : print('apple');
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Image.asset(
          path,
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}
