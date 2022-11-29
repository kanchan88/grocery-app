import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/model/CartModel.dart';
import 'package:grocery_app/model/ProductModel.dart';
import 'package:grocery_app/screen/CartPageScreen.dart';
import 'package:badges/badges.dart';

class ProductDetails extends StatefulWidget {

  Product product;
  List<CartModel> addedToCart;
  int cartItemCount;
  ProductDetails({this.product, this.addedToCart, this.cartItemCount});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  String snackText;
  CartModel cartItem;
  int productCountInCart = 1;
  @override
  void initState() {
    cartItem = CartModel(
      count: productCountInCart,
      product: widget.product,
      totalPrice: productCountInCart*widget.product.price,
    );
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: kToolbarHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.green
          ),
          child: InkWell(
            onTap: () {
              print(widget.addedToCart);
              if(!widget.addedToCart.contains(cartItem)){
                widget.addedToCart.add(cartItem);
                setState(() {
                  widget.cartItemCount=widget.addedToCart.length;
                  snackText = "Product Added to Cart!";
                });
              }
              else{
                setState(() {
                  snackText = "Product Already in Cart!";
                });
              }
              final snackBar = SnackBar(
                backgroundColor: Colors.red,
                content: Text(snackText, style: TextStyle(fontSize: 16.0),),
                action: SnackBarAction(
                  label: 'Undo',
                  textColor: Colors.white,
                  onPressed: () {
                    widget.addedToCart.remove(widget.product);
                    setState(() {
                      widget.cartItemCount=widget.addedToCart.length;
                    });
                  },
                ),
                duration: Duration(seconds: 1),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag, color: Colors.white,size: 32.0,),
                SizedBox(width: 3.0,),
                Text("Add to Cart", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),)
              ],
            ),
          ),
        ),
      ),
    body: ListView(
            children: [
              Container(
                color: Colors.white,
                child: Stack(
                  children: [
//                    Image.network("${widget.product.image}", width: MediaQuery.of(context).size.width),
                    Image.network("${widget.product.image}", width: MediaQuery.of(context).size.width),
                    Positioned(
                      right: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0,right: 10.0),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CartPageScreen(cartItems: widget.addedToCart),));
                          },
                          child: Badge(
                            animationDuration: Duration(seconds: 1),
                            badgeColor: Colors.orangeAccent,
                            toAnimate: true,
                            badgeContent: Text("${widget.cartItemCount}", style: TextStyle(color: Colors.white),),
                            child:Icon(Icons.shopping_bag, color: Colors.green,),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.green),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  color: Colors.grey.shade50,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10.0, top:10.0, bottom:5.0, right: 10.0),
                        child: Center(child: Text("${widget.product.name}", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),)),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child:Center(child: Text("Rs. ${widget.product.price}/kg", style: TextStyle(fontSize: 16.0, color: Colors.grey),)),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom:15.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Rs. ${widget.product.price}"),
                              Text("18 calorie/kg"),
                              Text("4.5 Rated(456)")
                            ],
                          ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              padding: EdgeInsets.all(5.0),
                              child: Icon(Icons.remove, color: Colors.white, size: 16.0,)
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:8.0, right: 8.0),
                              child: Text("1 Kg", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                padding: EdgeInsets.all(5.0),
                                child: Icon(Icons.add, color: Colors.white,size: 16.0,)
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  color: Colors.grey.shade50,
                ),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Product Description", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                      Text("A product description is the marketing copy that explains what a product is and why it's worth purchasing. The purpose of a product description is to supply customers with important information about the features and benefits of the product so they're compelled to buy.")
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }
}