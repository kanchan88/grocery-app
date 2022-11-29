import 'package:grocery_app/model/OrderModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screen/HomeBloc.dart';

Future<List<OrderModel>> fetchOrders (id) async {
  final data = await http.get(Uri.parse('$apiBaseUrl/api/my-order/$id'));
  var jsonData = json.decode(data.body);
  print(jsonData);
  List<OrderModel> myOrders = [];

  for (var p in jsonData) {
    OrderModel ofr = OrderModel(
      orderNumber: p['order_number'],
      items: p['items'],
      price: p['price'],
      deliveryDate: p['delivery_date'],
      deliveryStatus: p['delivery_status'],
      paymentStatus: p['payment_method']
    );
    myOrders.add(ofr);
  }

  print(myOrders.length);

  return myOrders;
}
