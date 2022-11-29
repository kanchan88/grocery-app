import 'package:flutter/material.dart';
import 'package:grocery_app/repo/LoginData.dart';
import 'package:grocery_app/screen/HomeBloc.dart';
import 'package:grocery_app/screen/LoginScreen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      ChangeNotifierProvider(
          create: (context)=>AppData(),
          child: MyApp()
      )
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Alpha Grocery',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: LoginPage().routeId,
        routes:{
          LoginPage().routeId:(context)=>LoginPage(),
          HomeBlocScreen().routeId:(context)=>HomeBlocScreen(),
        },
    );
  }
}