import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import '../models/order_model.dart';
import 'cart.dart';

class Order with ChangeNotifier {
  List<OrderItem> _order = [];
  List<OrderItem> get orders {
    return [..._order];
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final timeStamp = DateTime.now();
    const url = 'https://test-project-53c14.firebaseio.com/oders.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'product': cartProduct
                .map(
                  (cartProd) => {
                    'id': cartProd.id,
                    'price': cartProd.price,
                    'quantity': cartProd.quantity,
                    'title': cartProd.title,
                  },
                )
                .toList(),
          }));
      _order.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timeStamp,
          products: cartProduct,
        ),
      );
      notifyListeners();
      if (response.statusCode >= 400) {
        throw HttpException(
            'Error occured during sending order to firebase ->order.dart');
      }
    } catch (e) {
      print(e);
    }
  }
}
