import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:edu_nova/screens/subscriptions_screen.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/screens/profile_screen.dart';
import 'package:edu_nova/screens/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  static const routeName = '/tabs';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pages = [
      {
        'page': const HomeScreen(),
        'title': AppLocalizations.of(context)!.home,
        'icon': Icons.home_outlined,
      },
      // {
      //   'page': const ChatScreen(),
      //   'title': 'Chat',
      //   'icon': Icons.chat_outlined,
      // },
      {
        'page': const SubscriptionsScreen(),
        'title': AppLocalizations.of(context)!.subscriptions,
        'icon': Icons.favorite_outline,
      },
      {
        'page': const ProfileScreen(),
        'title': AppLocalizations.of(context)!.profile,
        'icon': Icons.tag_faces_outlined,
      },
    ];
    return Scaffold(
      body: pages[_selectedPageIndex]['page'],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GNav(
          selectedIndex: _selectedPageIndex,
          onTabChange: _selectPage,
          rippleColor: kMainSwatchColor.shade400,
          gap: 8,
          color: kMainSwatchColor,
          activeColor: kLightColor,
          tabBackgroundColor: kMainSwatchColor,
          padding: const EdgeInsets.all(16.0),
          tabs: [
            GButton(
              icon: pages[0]['icon'],
              text: pages[_selectedPageIndex]['title'],
            ),
            GButton(
              icon: pages[1]['icon'],
              text: pages[_selectedPageIndex]['title'],
            ),
            GButton(
              icon: pages[2]['icon'],
              text: pages[_selectedPageIndex]['title'],
            ),
            // GButton(
            //   icon: pages[3]['icon'],
            //   text: pages[_selectedPageIndex]['title'],
            // ),
          ],
        ),
      ),
    );
  }
}
