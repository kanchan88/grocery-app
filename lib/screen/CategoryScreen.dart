import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery_app/model/CartModel.dart';
import 'package:grocery_app/model/CategoryModel.dart';
import 'package:grocery_app/model/ProductModel.dart';
import 'package:grocery_app/screen/HomeBloc.dart';
import 'package:grocery_app/screen/ProductDetailScreen.dart';
import 'package:http/http.dart' as http;


class CategoryScreen extends StatefulWidget {

  final CategoryModel category;
  final List<Product> allProds;
  final List<CartModel> cartItems;

  CategoryScreen({this.category, this.cartItems, this.allProds});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  List<Product> allProducts;

  @override
  void initState() {
    allProducts = widget.allProds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          child: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.white,
            child:Icon(Icons.shopping_basket, color: Colors.green, size: 36,),
          ),
          backgroundColor: Colors.green,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.dashboard, color: Colors.white, size: 32.0,),
                    Text("Home", style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.description, color: Colors.white,size: 32.0,),
                    Text("Orders", style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
              SizedBox(width: 6.0),
              InkWell(
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.local_offer, color: Colors.white, size: 32,),
                    Text("Offers", style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.settings, color: Colors.white, size: 32.0,),
                    Text("More", style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        toolbarHeight: kToolbarHeight*1.2,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.category.name),
      ),
      body: Container(
        color: Colors.green,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
              color: Colors.grey.shade50
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
              color: Colors.white,
            ),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: allProducts.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(6.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(product: allProducts[index], addedToCart: widget.cartItems, cartItemCount: widget.cartItems.length,),  ));
                      },
                      child: Card(
                        elevation: 2.0,
                        child: Column(
                          children: [
                            Image.network("${allProducts[index].image}", height: 140.0,),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(allProducts[index].name),
                                  Text("Rs. ${allProducts[index].markedPrice}"),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
            ),
          ),
        ),
      ),
    );
  }
}