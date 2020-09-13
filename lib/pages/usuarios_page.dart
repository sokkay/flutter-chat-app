import 'package:animations/animations.dart';
import 'package:chat/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';

import 'package:chat/pages/main_page/chats_page.dart';
import 'package:chat/pages/discover_page.dart';
import 'package:chat/pages/settings_page.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  int _currentPage = 1;

  List<Widget> _pages = [DiscoverPage(), ChatsPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: PageTransitionSwitcher(
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
            return FadeThroughTransition(
              child: child,
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
            );
          },
          child: _pages[_currentPage],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentPage,
          onTap: _handleBottomTap,
          items: [
            CustomBottomNavBarItem(
              icon: Icons.navigation,
              title: 'Descubrir',
              selectedColor: Colors.blue[300],
              boxColor: Colors.blue[50],
            ),
            CustomBottomNavBarItem(
              icon: Icons.chat,
              title: 'Chats',
              selectedColor: Colors.pink[200],
              boxColor: Colors.pink[50],
            ),
            CustomBottomNavBarItem(
              icon: Icons.settings,
              title: 'Opciones',
              selectedColor: Colors.blueGrey[300],
              boxColor: Colors.blueGrey[50],
            ),
          ],
        ),
      ),
    );
  }

  void _handleBottomTap(int index) {
    setState(() {
      _currentPage = index;
    });
  }
}
