import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/order.dart';
import '../widgets/order_items.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/order-screen';

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;
  // @override
  // void initState() {
    // Future.delayed(Duration.zero).then((_) async {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   await Provider.of<Order>(context, listen: false).fetchAndSetOrders();
    //   setState(() {
    //     _isLoading = false;
    //   });
    // },
/*

ALTERNATIVELY


 */
    // setState(() {
    //   _isLoading = true;
    // });
    // Provider.of<Order>(context, listen: false).fetchAndSetOrders().then((_) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false).fetchAndSetOrders(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(child: Text('An Error Ocurred!'));
            } else {
              return Consumer<Order>(
                builder: (context, ordersData, _) {
                  return ListView.builder(
                    itemBuilder: (context, index) => OrderWidget(
                      order: ordersData.orders[index],
                    ),
                    itemCount: ordersData.orders.length,
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
