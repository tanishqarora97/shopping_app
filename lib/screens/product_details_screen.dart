import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details-screen';
  // ProductDetailsScreen({this.title});
  // final String title;

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedPages = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedPages.title),
      ),
    );
  }
}
