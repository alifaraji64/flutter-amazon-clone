import 'package:amazon_clone/features/address/screens/address_screen.dart';
import 'package:amazon_clone/features/address/screens/webview_screen.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/home/screens/category_deals_screen.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/features/account/widgets/buttom_bar.dart';
import 'package:amazon_clone/features/order_detail/screens/order_detail_screen.dart';
import 'package:amazon_clone/features/product_detail/screens/product_details_screen.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

import 'features/search/screens/search_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        builder: ((context) => const AuthScreen()),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        builder: ((context) => const HomeScreen()),
      );

    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        builder: ((context) => CategoryDealsScreen(category: category)),
      );

    case BottomBar.routeName:
      return MaterialPageRoute(
        builder: ((context) => const BottomBar()),
      );

    case AddProductScreen.routeName:
      return MaterialPageRoute(
        builder: ((context) => const AddProductScreen()),
      );

    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        builder: ((context) => SearchScreen(searchQuery: searchQuery)),
      );

    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        builder: ((context) => ProductDetailScreen(product: product)),
      );
    case AddressScreen.routeName:
      return MaterialPageRoute(
        builder: ((context) => const AddressScreen()),
      );
    case WebviewScreen.routeName:
      var invoice = routeSettings.arguments as String;
      return MaterialPageRoute(
        builder: ((context) => WebviewScreen(
              invoice: invoice,
            )),
      );
    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        builder: ((context) => OrderDetailScreen(
              order: order,
            )),
      );

    case AdminScreen.routeName:
      return MaterialPageRoute(
        builder: ((context) => const AdminScreen()),
      );

    default:
      return MaterialPageRoute(
        builder: ((context) => const AuthScreen()),
      );
  }
}
