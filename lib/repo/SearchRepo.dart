import 'package:http/http.dart' as http;
import '../screen/HomeBloc.dart';
import '../model/ProductModel.dart';
import 'dart:convert';

class SearchService{
  Future<List<Product>> searchProducts(String query) async {
    final data = await http.get(Uri.parse('$apiBaseUrl/api/search?search=$query'));
    var jsonData = json.decode(data.body);
    List<Product> searchedProducts = [];

    for (var p in jsonData) {
      Product ofr = Product(
        id: p['id'],
        weight: p['weight'],
        name: p['name'],
        description:p['description'],
        productDetail: p['product_detail'],
        markedPrice: p['marked_price'],
        price: p['price'],
        image: p['images'][0]['image'],
      );
      searchedProducts.add(ofr);
    }
    return searchedProducts;
  }
}