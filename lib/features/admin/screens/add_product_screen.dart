import 'dart:io';

import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/auth/widgets/custom_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../constants/GlobalVars.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../features/admin/services/admin_service.dart';

final AdminService adminService = AdminService();

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final _addProductFormKey = GlobalKey<FormState>();
  String category = 'Mobiles';
  List<File> images = [];
  List<String> categories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion',
  ];

  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
              //automaticallyImplyLeading: false,
              flexibleSpace: Container(
                decoration:
                    const BoxDecoration(gradient: GlobalVars.appBarGradient),
              ),
              title: const Text(
                'Add product',
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
                key: _addProductFormKey,
                child: Column(children: [
                  if (images.isNotEmpty)
                    Column(
                      children: [
                        CarouselSlider(
                          items: images.map((i) {
                            return Builder(
                                builder: (BuildContext context) => Image.file(
                                      i,
                                      fit: BoxFit.cover,
                                      height: 200,
                                    ));
                          }).toList(),
                          options: CarouselOptions(
                            viewportFraction: 1,
                            height: 200,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                images = [];
                              });
                            },
                            icon: const Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.red,
                              size: 36,
                            ))
                      ],
                    )
                  else
                    GestureDetector(
                      onTap: selectImages,
                      child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open_outlined,
                                  size: 40,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Select Product Images',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade500),
                                )
                              ],
                            ),
                          )),
                    ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: productNameController,
                    hintText: 'Product name',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: descriptionController,
                    hintText: 'Description',
                    maxLines: 6,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: priceController,
                    hintText: 'Price',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: quantityController,
                    hintText: 'Quantity',
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                      items: categories.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          category = value!;
                        });
                      },
                      value: category,
                      icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: 'Sell',
                    onPressed: () {
                      if (_addProductFormKey.currentState!.validate() ==
                              false ||
                          images.isEmpty) {
                        return;
                      }
                      adminService.addProduct(
                          context: context,
                          name: productNameController.text,
                          description: descriptionController.text,
                          price: double.parse(priceController.text),
                          quantity: int.parse(quantityController.text),
                          category: category,
                          images: images);
                    },
                  )
                ])),
          ),
        ));
  }
}
