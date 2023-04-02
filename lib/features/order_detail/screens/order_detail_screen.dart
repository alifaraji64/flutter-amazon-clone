import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/admin/screens/orders_screen.dart';
import 'package:amazon_clone/features/order_detail/services/order_detail_services.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/GlobalVars.dart';
import '../../../models/order.dart';
import '../../search/screens/search_screen.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = '/order-detail';
  Order order;
  OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderDetailServices orderDetailServices = OrderDetailServices();

  @override
  Widget build(BuildContext context) {
    bool isAdmin =
        Provider.of<UserProvider>(context, listen: false).user.role == 'admin';
    int currentStep = widget.order.status;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const AdminScreen();
        }));
        return false;
      },
      child: Scaffold(
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
                              Navigator.pushNamed(
                                  context, SearchScreen.routeName,
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
                                  borderSide:
                                      BorderSide(color: Colors.black38)),
                            ),
                          )),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(Icons.notifications),
                      )
                    ]),
                  )
                ],
              ),
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'View Order Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black12,
                  )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Date:   ${DateFormat().format(widget.order.orderedAt)}',
                      ),
                      Text(
                        'Order Total:   \$${widget.order.subTotal}',
                      ),
                      Text(
                        'Order Id:   ${widget.order.id}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Purchase Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black12,
                  )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < widget.order.products.length; i++)
                        Row(
                          children: [
                            Image.network(
                              widget.order.products[i].images[0],
                              height: 120,
                              width: 120,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.order.products[i].name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                ),
                                Text(
                                    'QTY: ${widget.order.quantity[i].toString()}')
                              ],
                            ))
                          ],
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tracking',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black12,
                  )),
                  child: Stepper(
                    currentStep: currentStep,
                    controlsBuilder: (context, details) {
                      if (isAdmin) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            currentStep != 3
                                ? MaterialButton(
                                    onPressed: () async {
                                      widget.order = await orderDetailServices
                                          .changeOrderStatus(
                                        context: context,
                                        order: widget.order,
                                        type: 'increment',
                                      );
                                      setState(() {
                                        currentStep = currentStep + 1;
                                      });
                                    },
                                    color: GlobalVars.secondaryColor,
                                    child: const Text(
                                      'countine',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : const SizedBox(),
                            currentStep != 0
                                ? MaterialButton(
                                    onPressed: () async {
                                      widget.order = await orderDetailServices
                                          .changeOrderStatus(
                                        context: context,
                                        order: widget.order,
                                        type: 'decrement',
                                      );
                                      setState(() {
                                        currentStep = currentStep - 1;
                                      });
                                    },
                                    color: Colors.grey,
                                    child: const Text(
                                      'cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                    steps: [
                      Step(
                          title: const Text('Pending'),
                          content:
                              const Text('Your order is yet to be delivered'),
                          isActive: currentStep == 0,
                          state: currentStep == 0
                              ? StepState.indexed
                              : StepState.complete),
                      Step(
                          title: const Text('Completed'),
                          content: const Text(
                              'Your order is yet to be delivered, you are yet to sign.'),
                          isActive: currentStep == 1,
                          state: currentStep < 1
                              ? StepState.indexed
                              : StepState.complete),
                      Step(
                          title: const Text('Received'),
                          content: const Text(
                              'Your order is has been delivered and signed by you'),
                          isActive: currentStep == 2,
                          state: currentStep < 2
                              ? StepState.indexed
                              : StepState.complete),
                      Step(
                          title: const Text('Delivered'),
                          content: const Text(
                              'Your order is has been delivered and signed by you'),
                          isActive: currentStep == 3,
                          state: currentStep < 3
                              ? StepState.indexed
                              : StepState.complete),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
