import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId,this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final one = dotenv.env['SECOND'];
    final two = 'orders/';
    final token = '$userId.json?auth=$authToken';
    final url = one + two + token;
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
       _orders = [];
     notifyListeners();
      return;
    }
    extractedData.forEach((orderId, orderData) => {
      print(orderData['products']),
          loadedOrders.add(
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              dateTime: DateTime.parse(
                orderData['dateTime'],
              ),
              products: (orderData['products'] as List<dynamic>).map((item) => CartItem(
                        id: item['id'],
                        price: item['price'],
                        quantity: item['quantity'],
                        title: item['title'],
                      ))
                  .toList(),
            ),
          )
        });
        _orders = loadedOrders.reversed.toList();
        notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final one = dotenv.env['SECOND'];
    final two = 'orders/$userId.json?auth=$authToken';
    var url = one + two ;
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
        'dateTime': timestamp.toIso8601String(),
      }),
    );
    await _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}

