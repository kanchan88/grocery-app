import 'package:grocery_app/model/ProductModel.dart';

class CategoryModel{
  int id;
  String imageUrl;
  String name;
  String description;
  List products;

  CategoryModel({this.id, this.imageUrl, this.name, this.products, this.description});

  CategoryModel.fromJson(Map<String, dynamic> p){
    id = p['id'];
    name= p['name'];
    description= p['description'];
    imageUrl= p['images'];
    products = p['products'];
  }
}