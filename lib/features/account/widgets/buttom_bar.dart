import 'package:amazon_clone/constants/GlobalVars.dart';
import 'package:amazon_clone/features/account/screens/account_screen.dart';
import 'package:amazon_clone/features/cart/screens/cart_screen.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen()
  ];
  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    int cartLength = context.watch<UserProvider>().user.cart.length;
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
                child: const Icon(Icons.person_outline),
              )),
          BottomNavigationBarItem(
              label: 'card',
              icon: badges.Badge(
                badgeContent: Text(cartLength.toString()),
                child: Container(
                  width: 42,
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            width: 5,
                            color: _page == 2
                                ? GlobalVars.selectedNavBarColor
                                : GlobalVars.unselectedNavBarColor)),
                  ),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              )),
        ],
        iconSize: 28,
      ),
    );
  }
}
