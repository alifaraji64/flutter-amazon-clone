import 'package:amazon_clone/features/admin/screens/orders_screen.dart';
import 'package:amazon_clone/features/admin/screens/posts_screen.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../../../constants/GlobalVars.dart';

class AdminScreen extends StatefulWidget {
  static const String routeName = '/admin';
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  AuthService authService = AuthService();
  int _page = 0;
  List<Widget> pages = [
    const PostsScreen(),
    const Center(
      child: Text('Analytics page'),
    ),
    const OrdersScreen(),
  ];
  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVars.selectedNavBarColor,
        unselectedItemColor: GlobalVars.unselectedNavBarColor,
        onTap: updatePage,
        items: [
          BottomNavigationBarItem(
              label: 'homepage',
              icon: Container(
                width: 42,
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 5,
                          color: _page == 0
                              ? GlobalVars.selectedNavBarColor
                              : GlobalVars.unselectedNavBarColor)),
                ),
                child: const Icon(Icons.home_outlined),
              )),
          BottomNavigationBarItem(
              label: 'profile',
              icon: Container(
                width: 42,
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 5,
                          color: _page == 1
                              ? GlobalVars.selectedNavBarColor
                              : GlobalVars.unselectedNavBarColor)),
                ),
                child: const Icon(Icons.analytics_outlined),
              )),
          BottomNavigationBarItem(
              label: 'card',
              icon: Container(
                width: 42,
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 5,
                          color: _page == 2
                              ? GlobalVars.selectedNavBarColor
                              : GlobalVars.unselectedNavBarColor)),
                ),
                child: const Icon(Icons.all_inbox_outlined),
              )),
        ],
        iconSize: 28,
      ),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVars.appBarGradient),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'assets/amazon_in.png',
                    width: 120,
                    height: 46,
                    color: Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Admin',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    IconButton(
                        onPressed: () {
                          authService.logout(context: context);
                        },
                        icon: const Icon(Icons.logout))
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
