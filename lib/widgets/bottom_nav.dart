import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:who_knows/config/constants.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:who_knows/screens/history.dart';
import 'package:who_knows/screens/pickup_layout.dart';
import 'package:who_knows/screens/search.dart';
import 'package:who_knows/screens/settings.dart';
import 'package:who_knows/screens/stats.dart';
import 'package:who_knows/screens/user_profile.dart';

class BottomNav extends StatefulWidget {
  final int startPage;
  final User user;

  const BottomNav({Key key, @required this.startPage, this.user})
      : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _page = 0;
  final _pageOption = [
    SearchScreen(),
    StatsScreen(),
    UserProfileScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  final appSystemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: appTheme,
      systemNavigationBarIconBrightness: Brightness.light);

  @override
  void initState() {
    super.initState();
    _setPage(widget.startPage);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
            index: widget.startPage,
            backgroundColor: appTheme,
            color: Colors.white,
            height: 60,
            animationCurve: Curves.easeOutQuint,
            items: <Widget>[
              Icon(Icons.home, color: appTheme, size: 30),
              Icon(Icons.insert_chart, color: appTheme, size: 30),
              Icon(Icons.person, color: Colors.orange[800], size: 30),
              Icon(Icons.history, color: appTheme, size: 30),
              Icon(Icons.settings, color: appTheme, size: 30),
            ],
            onTap: (index) {
              _setPage(index);
            },
          ),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            child: _pageOption[_page],
            value: appSystemTheme,
          )),
    );
  }

  void _setPage(index) {
    setState(() {
      _page = index;
    });
  }
}
