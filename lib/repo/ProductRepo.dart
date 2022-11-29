import 'package:http/http.dart' as http;
import '../model/ProductModel.dart';
import 'dart:convert';
import '../screen/HomeBloc.dart';

class ProductRepo {
  Future<List<Product>> fetchProducts () async {
    final data = await http.get(Uri.parse('$apiBaseUrl/api/product'));
    var jsonData = json.decode(data.body);

    List<Product> allProducts = [];

    for (var p in jsonData) {
      Product prod = Product(
          id: p['id'],
          weight: p['weight'],
          name: p['name'],
          description: p['description'],
          productDetail: p['product_detail'],
          markedPrice: p['marked_price'],
          price: p['price'],
          image: p['images'][0]['image']);
      allProducts.add(prod);
    }

    return allProducts;
  }
}