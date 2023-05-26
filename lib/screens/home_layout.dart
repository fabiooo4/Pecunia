import 'package:flutter/material.dart';
import 'package:pecunia/screens/statistics/statistics.dart';

import '../widgets/navigation_bar.dart';
import 'dashboard/dashboard.dart';
import 'other/other.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  static final List<Widget> _pages = [
    const Dashboard(),
    const Statistics(),
    const Other(),
  ];

  int _index = 0;

  void _onTabChange(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: NavBar(
        active: _index,
        onTabChange: _onTabChange,
      ),
    );
  }
}
