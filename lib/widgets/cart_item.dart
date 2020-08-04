import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  CartItem({
    this.quantity,
    this.price,
    this.id,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 15.0,
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(child: Text('\$${price}')),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total:\$ ${price * quantity}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
