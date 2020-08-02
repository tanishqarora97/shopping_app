import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './provider/product_provider.dart';
import './screens/product_overview_sceen.dart';
import './screens/product_details_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Products(),
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: GoogleFonts.lato().fontFamily,
        ),
        routes: {
          ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
        },
        home: ProductOverviewScreen(),
      ),
    );
  }
}
