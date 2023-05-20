import 'package:flutter/material.dart';
import 'package:pecunia/widgets/navigation_bar.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: const Center(
        child: Text('Statistics'),
      ),
      bottomNavigationBar: const NavBar(active: 1),
    );
  }
}
