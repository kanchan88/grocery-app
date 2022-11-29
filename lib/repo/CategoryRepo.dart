import 'package:http/http.dart' as http;
import '../model/CategoryModel.dart';
import 'dart:convert';
import '../screen/HomeBloc.dart';


Future<List<CategoryModel>> fetchCategory () async {
    final data = await http.get(Uri.parse('$apiBaseUrl/api/category'));
    var jsonData = json.decode(data.body);
    List<CategoryModel> allCategory = [];

    jsonData.forEach((json){
      allCategory.add(CategoryModel.fromJson(json));
    });

    print(allCategory);

    return allCategory;
  }
