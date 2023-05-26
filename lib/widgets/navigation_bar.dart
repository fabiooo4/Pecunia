import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBar extends StatefulWidget {
  final int active;

  const NavBar({Key? key, required this.active}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.active;
  }

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  static final List<String> _pages = [
    '/dashboard',
    '/statistics',
    '/other',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF072E08),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: GNav(
          selectedIndex: _index,
          duration: const Duration(milliseconds: 400),
          backgroundColor: const Color(0xFF072E08),
          color: Colors.lightGreen,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.lightGreen,
          gap: 8,
          padding: const EdgeInsets.all(18),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          onTabChange: (index) {
            context.push(_pages[index]);
            _onItemTapped(index);
          },
          tabs: const [
            GButton(
              icon: Icons.dashboard,
              text: 'Dashboard',
            ),
            GButton(
              icon: Icons.timeline,
              text: 'Statistics',
            ),
            GButton(
              icon: Icons.more_horiz,
              text: 'Other',
            ),
          ],
        ),
      ),
    );

    /*return CurvedNavigationBar(
      items: const <Widget>[
        Icon(Icons
            .dashboard),
        Icon(Icons
            .timeline),
        Icon(Icons
            .person),
      ],
      onTap:
          (index) {
        context
            .go(_pages[index]);
        _onItemTapped(
            index);
      },
      index:
          _index,
      height:
          50,
      color: Colors
          .white,
      buttonBackgroundColor:
          Color(
              0xFF072E08),
      backgroundColor:
          Colors
              .white,
      animationCurve:
          Curves
              .easeInOut,
      animationDuration:
          const Duration(
              milliseconds: 500),
    );
  }*/

    // return BottomNavigationBar(
    //   backgroundColor: Colors.white,
    //   elevation: 0,
    //   currentIndex: _index,
    //   onTap: (index) {
    //     context.push(_pages[index]);
    //     _onItemTapped(index);
    //   },
    //   items: const <BottomNavigationBarItem>[
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.dashboard),
    //       label: 'Dashboard',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.timeline),
    //       label: 'Statistics',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.more_horiz),
    //       label: 'Other',
    //     ),
    //   ],
    // );
  }
}
