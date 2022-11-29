import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/model/CartModel.dart';
import 'package:grocery_app/screen/LoginScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:grocery_app/screen/HomeBloc.dart';
import '../screen/HomeBloc.dart';

class CheckoutPage extends StatefulWidget {

  List<CartModel> productsInCheckout;

  CheckoutPage({this.productsInCheckout});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

enum PaymentOption {COD, BANK, WALLET}
enum DeliveryAddress {HOME, OFFICE, OTHER}


class _CheckoutPageState extends State<CheckoutPage> {

  bool orderStatus=false;

  String addressName;
  int id = 0;

  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController postcode = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController deliveryDate = TextEditingController();
  TextEditingController deliveryAddressController = TextEditingController();

  List<String> deliveryAddress = [];

  pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year+1),
    );

    if(date !=null){
      setState(() {
        deliveryDate.text = date.year.toString() +"-"+ date.month.toString() +"-"+date.day.toString();
      });
    }
  }


  createOrder(List<CartModel> productDetail) async {

    double cartTotal=0;
    List<Map<String, dynamic>> orders = [] ;

    for(int i=0; i<productDetail.length; i++){
      orders.add({
        "quantity":productDetail[i].count,
        "prod":productDetail[i].product.id
      });
      cartTotal = cartTotal+productDetail[i].totalPrice;
    }
    setState(() {
      orderStatus=false;
    });

    final response = await http.post(
      Uri.parse('$apiBaseUrl/api/order'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, dynamic>{
        "items": orders,
        "delivery_date": "${deliveryDate.text}T06:05:35.629238Z",
        "price": cartTotal,
        "payment_method": _payment,
        "delivery_status": "Processing",
        "order_address": [
          {
            "address_1": address1.text,
            "address_2": address2.text,
            "city": city.text,
            "state": state.text,
            "postcode": "44600",
            "country": country.text,
          }
        ],
        "order_user":userId
      }),
    );

    if(response.statusCode==201){
      setState(() {
        orderStatus=true;
      });
    }
  }

  PaymentOption _payment = PaymentOption.COD;
  String _address ="HOME";


  @override
  Widget build(BuildContext context) {
    return orderStatus==true?Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 100),
        child: Center(
            child: Column(
              children: [
                Text("Your Order is Complete"),
                ElevatedButton(
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>HomeBlocScreen()));
                    },
                    child: Text("Go Home"))
              ],
            )
        ),
      ),
    ):Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
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
            onTap: ()=>createOrder(this.widget.productsInCheckout),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag, color: Colors.white,size: 32.0,),
                SizedBox(width: 3.0,),
                Text("Place Order", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),)
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text("Payment Type", style: TextStyle(fontSize: 16.0),),
            ),
            ListTile(
              leading: Image.asset('assets/images/esewa.png', height: 40,),
              trailing: Radio(
                value: PaymentOption.WALLET,
                groupValue: _payment,
                onChanged: (PaymentOption value) {
                  setState(() {
                    _payment = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: Image.asset('assets/images/bank.png', height: 40,),
              trailing: Radio(
                value: PaymentOption.BANK,
                groupValue: _payment,
                onChanged: (PaymentOption value) {
                  setState(() {
                    _payment = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: Image.asset('assets/images/cod.png'),
              trailing: Radio(
                value: PaymentOption.COD,
                groupValue: _payment,
                onChanged: (PaymentOption value) {
                  setState(() {
                    _payment = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text("Delivery Details", style: TextStyle(fontSize: 16.0),),
            ),
            deliveryAddress.length==0?Container():
            Container(
              height: 70,
              child: ListView.builder(
                  itemCount: deliveryAddress.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(deliveryAddress[index], style: TextStyle(color: Colors.black54),),
                      trailing: IconButton(
                        onPressed: (){
                          setState(() {
                            deliveryAddress.remove(deliveryAddress[index]);
                          });
                        },
                        icon: Icon(Icons.delete)
                      ),
                      leading: Radio(
                        groupValue: id,
                        value: index,
                        onChanged: (val) {
                          setState(() {
                            address1.text = deliveryAddress[index] ;
                            id = index;
                          });
                        },
                      ),
                    );
                  },
              ),
            ),
            Container(
              height: 70,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
              ),
              child: ElevatedButton(
                  onPressed: () async {
                    await showDialog(
                    context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(2)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextFormField(
                                  onChanged: (e) {
                                    setState(() {
                                      addressName = e;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Address Title",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        deliveryAddress.add(addressName);
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("Add Address"))
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  },
                  style: ElevatedButton.styleFrom(),
                  child: Text("+ Delivery Location", style: TextStyle(fontSize: 16.0),)),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onTap: (){
                  pickDate();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Provide Date';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Delivery Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                controller: deliveryDate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Container(
//child: ListView(
//children: [
//Container(
//padding: const EdgeInsets.all(8.0),
//width: MediaQuery.of(context).size.width*.95,
//child: TextFormField(
//controller: address1,
//validator: (value) {
//if (value.isEmpty) {
//return 'Address is Missing';
//}
//return null;
//},
//onFieldSubmitted: (val){
//address1.text = val;
//},
//onEditingComplete: () => FocusScope.of(context).nextFocus(),
//decoration: InputDecoration(
//border: OutlineInputBorder(),
//labelText: "Address",
//),
//),
//),
//Container(
//padding: const EdgeInsets.all(8.0),
//width: MediaQuery.of(context).size.width*.95,
//child: TextFormField(
//controller: address2,
//validator: (value) {
//if (value.isEmpty) {
//return 'Local Places is missing';
//}
//return null;
//},
//onFieldSubmitted: (val){
//address2.text = val;
//},
//onEditingComplete: () => FocusScope.of(context).nextFocus(),
//decoration: InputDecoration(
//border: OutlineInputBorder(),
//labelText: "Locality",
//),
//),
//),
//Container(
//padding: const EdgeInsets.all(8.0),
//width: MediaQuery.of(context).size.width*.95,
//child: TextFormField(
//controller: city,
//validator: (value) {
//if (value.isEmpty) {
//return 'City is missing';
//}
//return null;
//},
//onFieldSubmitted: (val){
//city.text = val;
//},
//onEditingComplete: () => FocusScope.of(context).nextFocus(),
//decoration: InputDecoration(
//border: OutlineInputBorder(),
//labelText: "City",
//),
//),
//),
//Container(
//padding: const EdgeInsets.all(8.0),
//width: MediaQuery.of(context).size.width*.95,
//child: TextFormField(
//controller: state,
//validator: (value) {
//if (value.isEmpty) {
//return 'State is Missing';
//}
//return null;
//},
//onFieldSubmitted: (val){
//state.text = val;
//},
//onEditingComplete: () => FocusScope.of(context).nextFocus(),
//decoration: InputDecoration(
//border: OutlineInputBorder(),
//labelText: "State",
//),
//),
//),
//Container(
//padding: const EdgeInsets.all(8.0),
//width: MediaQuery.of(context).size.width*.95,
//child: TextFormField(
//controller: country,
//validator: (value) {
//if (value.isEmpty) {
//return 'Country is Missing';
//}
//return null;
//},
//onFieldSubmitted: (val){
//address1.text = val;
//},
//onEditingComplete: () => FocusScope.of(context).nextFocus(),
//decoration: InputDecoration(
//border: OutlineInputBorder(),
//labelText: "Country",
//),
//),
//),
//Padding(
//padding: const EdgeInsets.all(8.0),
//child: TextFormField(
//onTap: (){
//pickDate();
//},
//validator: (value) {
//if (value.isEmpty) {
//return 'Please Provide Date';
//}
//return null;
//},
//decoration: InputDecoration(
//hintText: "Delivery Date",
//border: OutlineInputBorder(),
//),
//controller: deliveryDate,
//),
//),
//Padding(
//padding: const EdgeInsets.all(8.0),
//child: DropdownButtonFormField(
//validator: (value) => value == null
//? 'Please provide payment option' : null,
//onChanged: (val){
//paymentOption.text = val;
//},
//decoration: InputDecoration(
//border: OutlineInputBorder(
//)
//),
//hint: Text("Payment Options", style: TextStyle(fontFamily: "Gotham",),),
//items: [
//DropdownMenuItem(child: Text("Esewa"),
//value: "ESEWA",),
//DropdownMenuItem(child: Text("Khalti"),
//value: "KHALTI",),
//DropdownMenuItem(child: Text("Bank"),
//value: "BANK",),
//DropdownMenuItem(child: Text("Cash on Delivery"),
//value: "COD",),
//DropdownMenuItem(child: Text("Paypal"),
//value: "PAYPAL",),
//],
//),
//),
//],
//),
//)