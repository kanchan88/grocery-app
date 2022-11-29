import 'package:flutter/material.dart';
import 'package:grocery_app/model/UserModel.dart';
import 'package:grocery_app/screen/HomeBloc.dart';
import 'package:grocery_app/screen/LoginScreen.dart';
import 'package:grocery_app/screen/ProfileScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SettingPage extends StatefulWidget {

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  User prod;

  getProfileDetail() async {
    final data = await http.get(Uri.parse('$apiBaseUrl/api/customer/$userId'));
    var jsonData = json.decode(data.body);
    setState(() {
      prod = User(
        username: jsonData['username'],
        email: jsonData['email'],
        password: jsonData['password'],
        phone: jsonData['customer']['phone'],
        birthday: jsonData['customer']['date_of_birth'],
      );
    });
  }


  handleSubmit() async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/api/logout/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':'Token $authToken',
      },
    );

    if(response.statusCode==204){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
    }
  }

  @override
  void initState() {
    getProfileDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            //for user profile header
            Container(
              color: Colors.green,
              padding: EdgeInsets.only(top: kToolbarHeight, bottom: kToolbarHeight*.55),
              child: ListTile(
//                leading: SizedBox(
//                    child: ClipOval(
//                      child: Image.network(
//                        '',
//                      ),
//                    )),
                title: Text(
                  "HELLO ${prod.username}",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  "${prod.email}",
                  style: TextStyle(
                      color: Colors.white70,
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 16),
                ),
                trailing: IconButton(
                    icon: Icon(Icons.exit_to_app, color: Colors.white,), onPressed: handleSubmit)
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        leading: Icon(Icons.reorder, color: Colors.green,),
                        title:Text("My Orders"),
                        trailing: Icon(Icons.keyboard_arrow_right, color:Colors.black),
                      )
                  ),
                  SizedBox(height: 6.0,),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        leading: Icon(Icons.store, color: Colors.green,),
                        title:Text("Offers"),
                        trailing: Icon(Icons.keyboard_arrow_right, color:Colors.black),
                      )
                  ),
                  SizedBox(height: 6.0,),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: ListTile(
                          leading: Icon(Icons.send, color: Colors.green,),
                          title:Text("Invite Friends"),
                          trailing: Icon(Icons.keyboard_arrow_right, color:Colors.black),
                      )
                  ),
                  SizedBox(height: 6.0,),
                  InkWell(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),)),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius:BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          leading: Icon(Icons.list, color: Colors.green,),
                          title:Text("Settings"),
                          trailing: Icon(Icons.keyboard_arrow_right, color:Colors.black),
                        )
                    ),
                  ),
                  SizedBox(height: 6.0,),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        leading: Icon(Icons.help, color: Colors.green,),
                        title:Text("Help"),
                        trailing: Icon(Icons.keyboard_arrow_right, color:Colors.black),
                      )
                  ),
                  SizedBox(height: 6.0,),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        leading: Icon(Icons.phonelink_ring, color: Colors.green,),
                        title:Text("Contact"),
                        trailing: Icon(Icons.keyboard_arrow_right, color:Colors.black),
                      )
                  ),
                  SizedBox(height: 6.0,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}