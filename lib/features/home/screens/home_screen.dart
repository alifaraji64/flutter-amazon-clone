import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/home/widgets/carousel_image.dart';
import 'package:amazon_clone/features/home/widgets/deal_of_day.dart';
import 'package:amazon_clone/features/home/widgets/top_categories.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/GlobalVars.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVars.appBarGradient),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(7),
                        child: TextFormField(
                          onFieldSubmitted: (query) {
                            Navigator.pushNamed(context, SearchScreen.routeName,
                                arguments: query);
                          },
                          cursorColor: Colors.black38,
                          decoration: const InputDecoration(
                            hintText: 'Search product',
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            focusedBorder: OutlineInputBorder(
                                // borderRadius: BorderRadius.all(
                                //   Radius.circular(7),
                                // ),
                                borderSide: BorderSide(color: Colors.black38)),
                          ),
                        )),
                  ),
                ),
                Row(children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8, left: 8),
                    child: Icon(Icons.notifications),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        authService.logout(context: context);
                      },
                    ),
                  )
                ])
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            AddressBox(),
            SizedBox(height: 10),
            TopCategories(),
            SizedBox(height: 10),
            CarouselImage(),
            SizedBox(height: 10),
            DealOfDay()
          ],
        ),
      ),
    );
  }
}
