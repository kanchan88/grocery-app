import 'package:flutter/material.dart';
import 'package:grocery_app/screen/HomeBloc.dart';
import 'package:grocery_app/screen/LoginScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  String username;
  String password;
  String dateOfBirth;
  String phoneNumber;
  String email;

  bool error = false;
  bool isUserError = false;
  String userError;

  bool userSignUp = false;

  @override
  void initState() {
    super.initState();
  }

  handleSubmit() async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/api/customer'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, dynamic>{
        "username": username,
        "password": password,
        "email":email,
        "customer":{
          "phone": phoneNumber,
          "date_of_birth": "2000-07-06",
        }
      }),
    );

    if(response.statusCode==201){
      await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Container(
                  child: Center(
                    child: Column(
                      children: [
                        Text("User Created", style: TextStyle(fontSize: 20.0),),
                        SizedBox(height: 10.0,),
                        Icon(Icons.check_circle_outline, size: 50.0, color: Colors.green,),
                        SizedBox(height: 10.0,),
                        ElevatedButton(onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),)), child: Text("Login to Continue"))
                      ],
                    ),
                  ),
                ),
              );
            }
        );
    }
    else{
      setState(() {
          isUserError = true;
      });
    }
  }

  Widget _submitButton() {
    return InkWell(
      onTap: ()=>handleSubmit(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.green, Colors.green])),
        child: Text(
          'SignUp',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }


  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        padding: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Image.asset('assets/images/logo.png', height: 120,);
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Username",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  onChanged: (val){
                    setState(() {
                      username = val;
                    });
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true),
              ),
              isUserError?Container(child: Text("Username is Missing/Already Exists", style: TextStyle(color: Colors.red),),):Container(),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  obscureText: true,
                  onChanged: (val){
                    setState(() {
                      password = val;
                    });
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true)
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  onChanged: (val){
                    setState(() {
                      email = val;
                    });
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true)),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Phone Number",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  onChanged: (val){
                    setState(() {
                      phoneNumber = val;
                    });
                  },
                keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true),
              ),
              error?Container(child: Text("Ssssh. Something went wrong!", style: TextStyle(color: Colors.red),),):Container(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .066),
                      _title(),
                      SizedBox(height: 30),
                      _emailPasswordWidget(),
                      SizedBox(height: 10),
                      _submitButton(),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}