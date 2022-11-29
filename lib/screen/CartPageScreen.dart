import 'package:flutter/material.dart';
import 'package:grocery_app/model/CartModel.dart';
import 'package:grocery_app/screen/CheckOutScreen.dart';

class CartPageScreen extends StatefulWidget {

  List<CartModel> cartItems;
  CartPageScreen({@required this.cartItems, key}):super(key: key);

  @override
  _CartPageScreenState createState() => _CartPageScreenState();
}

class _CartPageScreenState extends State<CartPageScreen> {

  double cartTotal=0;
  List<CartModel> myCartsInCartPage;

  void cartPrice(){
    setState(() {
      myCartsInCartPage.forEach((element) {
        cartTotal = cartTotal + element.product.price * element.count;
      });
    });
  }

  @override
  void initState() {
    myCartsInCartPage = widget.cartItems;
    cartPrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight*1.2,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Cart"),
      ),
      body: myCartsInCartPage.length==0?
      Container(
        child: Center(
          child: Text(
            "No items in cart\nGo back and add some",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ):
      Column(
        children: [
          Container(
            color: Colors.green,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
                  color: Colors.grey.shade50
              ),
              child: Container(
                height: MediaQuery.of(context).size.height*.75,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  itemCount: myCartsInCartPage.length,
                  itemBuilder: (context, index) {
                    final item = myCartsInCartPage[index];
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(color: Colors.red,),
                      onDismissed: (dir){
                        myCartsInCartPage.remove(item);
                        setState(() {
                          myCartsInCartPage.forEach((element) {
                            cartTotal = 0;
                            cartTotal = cartTotal + element.totalPrice;
                          });
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network("${myCartsInCartPage[index].product.image}", width: 120),
//                            Image.network("${myCartsInCartPage[index].image}", width: 120),
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:[
                                      Text("${myCartsInCartPage[index].product.name}", style: TextStyle(fontSize: 22.0),),
                                      Text("${myCartsInCartPage[index].product.weight}/items", style: TextStyle(fontSize: 16.0, color: Colors.grey),),
                                      Padding(
                                        padding: const EdgeInsets.only(top:10.0),
                                        child: Text("Rs.${myCartsInCartPage[index].totalPrice}", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green),),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          myCartsInCartPage[index].count = myCartsInCartPage[index].count +1;
                                          myCartsInCartPage[index].totalPrice = myCartsInCartPage[index].product.price* myCartsInCartPage[index].count;
                                          cartTotal = cartTotal + myCartsInCartPage[index].product.price;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Icon(Icons.add, color: Colors.black,size: 20.0,),),
                                      ),
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                        ),
                                        padding: EdgeInsets.all(5.0),
                                        child: Text("${myCartsInCartPage[index].count}", style: TextStyle(color: Colors.white, fontSize: 16.0,),)
                                    ),
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          if(myCartsInCartPage[index].count>1){
                                            myCartsInCartPage[index].count = myCartsInCartPage[index].count -1;
                                            myCartsInCartPage[index].totalPrice = myCartsInCartPage[index].product.price* myCartsInCartPage[index].count;
                                            cartTotal = cartTotal - myCartsInCartPage[index].product.price;
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Icon(Icons.remove, color: Colors.black,size: 20.0,),),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top:5.0),
                              color: Colors.grey.shade200,
                              height: 1.0,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            height: kToolbarHeight,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Cart Total Rs.$cartTotal/-", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutPage(productsInCheckout: myCartsInCartPage,),));
                        },
                        child: Text("Checkout>>", style: TextStyle(color: Colors.white, fontSize: 18.0,),)
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}