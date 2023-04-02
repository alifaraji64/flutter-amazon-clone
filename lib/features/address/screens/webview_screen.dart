import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../constants/GlobalVars.dart';
import '../../../models/user.dart';

class WebviewScreen extends StatelessWidget {
  static const String routeName = '/webview-screen';
  final String invoice;
  const WebviewScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..loadRequest(Uri.parse(invoice))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onProgress: (int progress) {
        // Update loading bar.
      }, onNavigationRequest: (NavigationRequest request) {
        if (request.url.contains('/paymentDone')) {
          print('to payment success screen');
          User user = Provider.of<UserProvider>(context, listen: false)
              .user
              .copyWith(cart: []);
          Provider.of<UserProvider>(context, listen: false).setUserModel(user);
          Provider.of<UserProvider>(context, listen: false).setCartSubtotal();
          return NavigationDecision.navigate;
        }
        return NavigationDecision.navigate;
      }));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVars.appBarGradient,
            ),
          ),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
