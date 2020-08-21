import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/order_model.dart';
import 'cart.dart';

class Order with ChangeNotifier {
  final String authToken;
  final String userId;
  Order(this.authToken, this._order,this.userId);
  List<OrderItem> _order = [];
  List<OrderItem> get orders {
    return [..._order];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://test-project-53c14.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    // print(json.decode(response.body));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    /*
    orderId = key
    orderData = value
    */
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['product'] as List<dynamic>)
            .map((items) => CartItem(
                  id: items['id'],
                  price: items['price'],
                  quantity: items['quantity'],
                  title: items['title'],
                ))
            .toList(),
      ));
    });
    _order = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final timeStamp = DateTime.now();
    final url =
        'https://test-project-53c14.firebaseio.com/orders/$userId.json?auth=$authToken';
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
