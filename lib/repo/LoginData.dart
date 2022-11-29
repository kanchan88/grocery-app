import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier{

  int uid;

  void updateUserId(userId){
    uid = userId;
    notifyListeners();
  }

}