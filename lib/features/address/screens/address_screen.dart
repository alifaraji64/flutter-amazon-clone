import 'package:amazon_clone/features/address/services/address_services.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/GlobalVars.dart';
import '../../../widgets/custom_textfield.dart';
import '../../auth/widgets/custom_button.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address-screen';
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final AddressServices addressServices = AddressServices();
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  bool newAddressExists = false;

  @override
  void dispose() {
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String address =
        Provider.of<UserProvider>(context, listen: true).user.address;
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              Form(
                  key: _addressFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          controller: flatBuildingController,
                          hintText: 'flat, house no, building',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          controller: areaController,
                          hintText: 'area, street',
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: pincodeController,
                          hintText: 'pincode',
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: cityController,
                          hintText: 'city',
                        ),
                        const SizedBox(height: 15),
                        CustomButton(
                          text: 'Pay',
                          onPressed: () async {
                            newAddressExists = false;
                            if (flatBuildingController.text.isNotEmpty ||
                                areaController.text.isNotEmpty ||
                                pincodeController.text.isNotEmpty ||
                                cityController.text.isNotEmpty) {
                              _addressFormKey.currentState!.validate();
                              newAddressExists = true;
                            }
                            if (newAddressExists) {
                              if (_addressFormKey.currentState!.validate()) {
                                await addressServices.setAdress(
                                  address:
                                      '${flatBuildingController.text} ${areaController.text} ${pincodeController.text} ${cityController.text}',
                                  context: context,
                                );
                                // ignore: use_build_context_synchronously
                                await addressServices.pay(context: context);
                                return;
                              }
                              return;
                            }
                            if (address.isEmpty && newAddressExists == false) {
                              // no address is set;
                              return;
                            }
                            await addressServices.pay(context: context);
                          },
                        ),
                      ],
                    ),
                  )),
              //WebViewWidget(controller: controller)
            ],
          ),
        ));
  }
}
