import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

import '../../account/widgets/single_product.dart';
import '../services/admin_service.dart';

final AdminService adminService = AdminService();

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  Future<List<Product>> getProducts() async {
    return await adminService.getProducts(context: context);
  }

  // @override
  // void initState() {
  //   getProducts();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getProducts(),
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Center(child: Text('unhadled exception'));
              }
              return GridView.builder(
                  itemCount: snapshot.data!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    final Product product = snapshot.data![index];
                    return Column(
                      //children: [Text(snapshot['name'].toString())],
                      children: [
                        SizedBox(
                          height: 140,
                          child: SingleProduct(image: product.images[0]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    print(product.id!);
                                    await adminService.deleteProduct(
                                        context: context,
                                        productId: product.id!);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                  ))
                            ],
                          ),
                        )
                      ],
                    );
                  });
            }
            return const Center(
              child: Center(child: Text('unhadled exception')),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddProductScreen.routeName);
        },
        tooltip: 'Add a product',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
