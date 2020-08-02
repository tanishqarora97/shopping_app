import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10.0),
      itemBuilder: (context, index) {
        return ProductItem(
          id: products[index].id,
          imageUrl: products[index].imageUrl,
          title: products[index].title,
        );
      },
      itemCount: products.length,
    );
  }
}
