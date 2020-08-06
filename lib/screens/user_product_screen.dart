import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../provider/product_provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    print(productData.items.length);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routename);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (ctx, index) => Column(
            children: [
              UserProductItem(
                id: productData.items[index].id,
                title: productData.items[index].title,
                imageUrl: productData.items[index].imageUrl,
              ),
              Divider()
            ],
          ),
          itemCount: productData.items.length,
        ),
      ),
    );
  }
}
