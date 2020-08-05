import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/order_model.dart';
import 'package:shop_app/provider/cart.dart';

class Order with ChangeNotifier {
  List<OrderItem> _order = [];
  List<OrderItem> get orders {
    return [..._order];
  }

  void addOrder(List<CartItem> cartProduct, double total) {
    _order.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProduct,
      ),
    );
    notifyListeners();
  }
}
