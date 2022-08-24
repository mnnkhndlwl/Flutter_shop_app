import 'package:flutter/material.dart';
import './screens/cart_screen.dart';
import '../providers/cart.dart';
import '../screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './widgets/product_item.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:(context) => Products(),
        ),
        ChangeNotifierProvider(
          create:(context) =>  Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.orange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(), 
        },
      ),
    );
  }
}
