import 'package:grocery_app/model/UserModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screen/HomeBloc.dart';

Future<List<User>> fetchUsers () async {
    final data = await http.get(Uri.parse('$apiBaseUrl/api/customer'));
    var jsonData = json.decode(data.body);

    List<User> users = [];

    for (var p in jsonData) {
      User prod = User(
          username: p['username'],
          password: p['password'],
      );
      users.add(prod);
    }

    return users;
  }