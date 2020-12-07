import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app_test/model/apierror.dart';
import 'package:flutter_app_test/model/contactsresponse.dart';
import 'package:flutter_app_test/networkmodel/APIHandler.dart';
import 'package:flutter_app_test/networkmodel/APIs.dart';



class HomeViewModel with ChangeNotifier {
  var _isLoading = false;

  getLoading() => _isLoading;


  Future<dynamic> getDoctorsList( BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(
        context: context, url: APIs.getContacts);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ContactsResponse homeResponse = new ContactsResponse.fromJson(response);
      print("response ${homeResponse}");
      completer.complete(homeResponse);
      notifyListeners();
      return completer.future;
    }
  }



  void hideLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setLoading() {
    _isLoading = true;
    notifyListeners();
  }
}
