import 'package:flutter/material.dart';
import 'package:grocery_app/model/OrderModel.dart';
import 'package:grocery_app/repo/OrderRepo.dart';
import 'package:grocery_app/screen/LoginScreen.dart';


class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {

  Future<List<OrderModel>> allOrders;

  @override
  void initState() {
    allOrders = fetchOrders(userId);
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
        title: Text("My Orders"),
      ),
      body: Column(
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
                child: FutureBuilder(
                  future: allOrders,
                  builder: (context, snapshot){
                    List<OrderModel> myOrders = snapshot.data ?? [];
                    if(snapshot.hasData){
                      return ListView.builder(
                        itemCount: myOrders.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Card(
                                elevation: 1.0,
                                color: Colors.green.shade50,
                                child: ListTile(
                                  title: Text("Order Number: ${myOrders[index].orderNumber}"),
                                  trailing: Text("${myOrders[index].deliveryStatus}"),
                                  subtitle: Row(
                                    children: [
                                      Text("Payment: Rs.${myOrders[index].price}"),
                                      Text(" Via ${myOrders[index].paymentStatus}")
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
