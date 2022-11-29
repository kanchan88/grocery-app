import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery_app/model/CartModel.dart';
import 'package:grocery_app/model/ProductModel.dart';
import 'package:grocery_app/repo/CategoryRepo.dart';
import 'package:grocery_app/repo/LoginData.dart';
import 'package:grocery_app/repo/OfferRepo.dart';
import 'package:grocery_app/screen/MyOrdersPage.dart';
import 'package:grocery_app/screen/ProductDetailScreen.dart';
import 'package:grocery_app/screen/SettingPage.dart';
import 'package:provider/provider.dart';
import '../bloc/ProductBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/ProductRepo.dart';
import 'package:bloc/bloc.dart';
import '../model/CategoryModel.dart';
import '../model/OfferModel.dart';
import '../screen/CategoryScreen.dart';
import '../repo/SearchRepo.dart';
import 'package:http/http.dart' as http;


//final apiBaseUrl = "http://192.168.1.74:8000";
final apiBaseUrl = "http://192.168.0.116:8000";

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

class HomeBlocScreen extends StatelessWidget {

  final String routeId = "/homebloc";

  ProductRepo productRepo = ProductRepo();

  List<CartModel> cartItems=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => ProductBloc(productRepo: productRepo),
      child: HomeBloc(cartsItem: cartItems,),
    ));
  }
}


class HomeBloc extends StatefulWidget {

  List<CartModel> cartsItem;
  HomeBloc({this.cartsItem});

  @override
  _HomeBlocState createState() => _HomeBlocState();
}

class _HomeBlocState extends State<HomeBloc> {

  Future<List<CategoryModel>> allCategories;
  Future<List<Offer>> allOffer;
  Future<List<Product>> searchResults;


  bool clickOnSearch = false;

  @override
  void initState() {
    allCategories = fetchCategory();
    allOffer = fetchOffers();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductIsNotLoaded) {
          BlocProvider.of<ProductBloc>(context).add(GetProducts());
        }

        if (state is ProductIsLoaded) {
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
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrders(),));
                      },
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
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage(),));
                      },
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
            body: Container(
              padding: EdgeInsets.only(top: 20.0),
              color: Color(0xFF27ae60),
              child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Hi Kanchan, \nWelcome to Alpha E-Grocery", style: TextStyle(fontSize: 16.0, color: Colors.white),),
                          CircleAvatar(
                            radius: 24.0,
                            backgroundImage:NetworkImage('https://www.web-soluces.net/webmaster/avatar/FaceYourManga-Femme.png'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
                      child: Container(
                          padding: const EdgeInsets.only(left: 15.0),
                          height: clickOnSearch?kToolbarHeight*3:kToolbarHeight*.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.0),
                              color: Color(0xFFf4f5f7)
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.search, color: Colors.grey,),
                                  Flexible(
                                    child: TextFormField(
                                      onChanged: (val){
                                        setState(() {
                                          if(val.length>2){
                                            clickOnSearch = true;
                                            searchResults = SearchService().searchProducts(val);
                                          }
                                          else{
                                            clickOnSearch = false;
                                          }
                                        });
                                      },
                                      onEditingComplete: (){
                                        setState(() {
                                          clickOnSearch = false;
                                        });
                                      },
                                      onFieldSubmitted: (h){
                                        setState(() {
                                          clickOnSearch = false;
                                          FocusScope.of(context).unfocus();
                                        });
                                      },
                                      decoration: InputDecoration(
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          hintText: "Search your Grocery Food Here..",
                                          hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey)
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              clickOnSearch?Container(
                                height: 100.0,
                                child: FutureBuilder(
                                  future: searchResults,
                                  builder: (context, snapshot) {
                                    List<Product> searches = snapshot.data ?? [];
                                    if(snapshot.hasData){
                                      return ListView.builder(
                                        itemCount: searches.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return buildResultCard(searches[index], context, widget.cartsItem);
                                        },
                                      );
                                    }
                                    return Container(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                                ),
                              ):Container(),
                            ],
                          )
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*.32,
                      padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(30.0), topRight:Radius.circular(30.0)),
                          color: Color(0xFFf4f5f7)
                      ),
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              color: Colors.white
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Categories", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 10.0),
                                child: Container(
                                  color: Colors.grey.shade300,
                                  height: 1.0,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 130,
                                child: FutureBuilder(
                                  future: allCategories,
                                  builder: (context, snapshot){
                                    List<CategoryModel> allCats = snapshot.data ?? [];
                                    if(snapshot.hasData){
                                      return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: allCats.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () async {
                                                List<Product> allProducts = [];

                                                  for(int k =0; k<allCats[index].products.length; k++){
                                                    final data = await http.get(Uri.parse('$apiBaseUrl/api/product/${allCats[index].products[k]}'));
                                                    var jsonData = json.decode(data.body);
                                                    Product prod = Product(
                                                        id: jsonData['id'],
                                                        weight: jsonData['weight'],
                                                        name: jsonData['name'],
                                                        description: jsonData['description'],
                                                        productDetail: jsonData['product_detail'],
                                                        markedPrice: jsonData['marked_price'],
                                                        price: jsonData['price'],
                                                        image: jsonData['images'][0]['image']);
                                                    allProducts.add(prod);
                                                  }

                                                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(category: allCats[index], allProds: allProducts, cartItems: widget.cartsItem,),));
                                              },
                                              child: Column(
                                                children: [
                                                  Card(
                                                    elevation: 1.0,
                                                    color: Colors.green.shade50,
                                                    child: Image.network("${allCats[index].imageUrl}", height: 100.0,),
                                                  ),
                                                  SizedBox(height: 4.0,),
                                                  Text("${allCats[index].name}", style: TextStyle(fontSize: 14.0),)
                                                ],
                                              ),
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
                            ],
                          )
                      ),
                    ),
                    Container(
                      height: 180,
                      color: Color(0xFFf4f5f7),
                      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 25.0, bottom: 20.0),
                      child: FutureBuilder(
                        future: allOffer,
                        builder: (context, snapshot) {
                          List<Offer> myOffer = snapshot.data ?? [];
                          if(snapshot.hasData){
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: myOffer.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.only(right: 15.0),
                                  child: Container(
                                    padding: EdgeInsets.all(20.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                        color: index%2==0?Colors.green.shade50:Colors.orange.shade50
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*.9,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Image.network("${myOffer[index].imageUrl}", height: 200,),
                                        ],
                                      ),
                                    ),
                                  ),
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
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                      decoration: BoxDecoration(
                          color: Color(0xFFf4f5f7)
                      ),
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              color: Colors.white
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("All Products", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),),
                                    Text("See all", style: TextStyle(fontSize: 16.0, color: Color(0xFF27ae60)),)
                                  ],
                                ),
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height*.60,
                                  child: BlocBuilder<ProductBloc, ProductState>(
                                    builder: (context, state) {
                                      if (state is ProductIsNotLoaded) {
                                        BlocProvider.of<ProductBloc>(context).add(GetProducts());
                                      }

                                      if (state is ProductIsLoaded) {
                                        return GridView.builder(
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                          itemCount: state.getProducts.length,
                                          itemBuilder: (context, index) {
                                            if(state.getProducts.length==0){
                                              return Center(
                                                child: Text("Error Occured"),
                                              );
                                            }
                                            return Container(
                                              padding: EdgeInsets.all(6.0),
                                              child: InkWell(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(product: state.getProducts[index], addedToCart: widget.cartsItem, cartItemCount: widget.cartsItem.length,),  ));
                                                },
                                                child: Card(
                                                  elevation: 2.0,
                                                  child: Column(
                                                    children: [
                                                      Image.network("${state.getProducts[index].image}", height: 140.0,),
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(state.getProducts[index].name),
                                                            Text("Rs. ${state.getProducts[index].markedPrice}"),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      return Center(
                                        child:CircularProgressIndicator(),
                                      );
                                    },
                                  ),
                              ),
                            ],
                          )
                      ),
                    )
              ],
            ),
          ),
          );
        }
        return Center(
          child:CircularProgressIndicator(),
          );
      },
    );
  }
}


Widget buildResultCard(Product data, context, cart) {

  return Padding(
    padding: EdgeInsets.zero,
    child: Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ProductDetails(product: data,
                  addedToCart: cart,
                  cartItemCount: cart.length,),));
          },
          child: ListTile(
            title: Text(data.name),
            subtitle: Text("Rs.${data.price}"),
          ),
        ),
      ],
    ),
  );
}