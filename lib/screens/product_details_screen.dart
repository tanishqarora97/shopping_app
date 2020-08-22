import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details-screen';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedPages = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      // appBar: AppBar(

      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: loadedPages.id,
                child: Image.network(
                  loadedPages.imageUrl,
                  //   width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(loadedPages.title),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '\$ ${loadedPages.price}',
                  style: TextStyle(color: Colors.grey, fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: double.infinity,
                  child: Text(
                    '\$ ${loadedPages.description}',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ],
        // child: Column(
        //   children: [
        //     Container(
        //       height: 300,
        //       child:
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
