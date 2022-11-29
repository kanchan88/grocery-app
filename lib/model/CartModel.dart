import 'ProductModel.dart';

class CartModel{
  int count;
  Product product;
  double totalPrice;

  CartModel({this.count, this.product, this.totalPrice});
}