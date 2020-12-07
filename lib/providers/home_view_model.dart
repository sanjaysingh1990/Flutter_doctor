import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app_test/localdb/DatabaseHelper.dart';
import 'package:flutter_app_test/model/apierror.dart';
import 'package:flutter_app_test/model/contactsresponse.dart';
import 'package:flutter_app_test/model/doctorcontact.dart';
import 'package:flutter_app_test/networkmodel/APIHandler.dart';
import 'package:flutter_app_test/networkmodel/APIs.dart';
import 'package:flutter_app_test/utils/widgets.dart';

class HomeViewModel with ChangeNotifier {
  var _isLoading = false;

  getLoading() => _isLoading;

  Future<dynamic> getDoctorsListLocal() async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var localDataList = await DatabaseHelper.instance.queryAllRows();
    //if not record found
    if (localDataList.length == 0) {
      completer.complete(APIError(status: 400, message: "No data found"));
      return completer.future;
    }
    ContactsResponse homeResponse =
    new ContactsResponse.fromJson(localDataList);
    print("response ${homeResponse}");
    completer.complete(homeResponse);
    return completer.future;
  }


  Future<dynamic> updateDoctorInformation(DoctorContact doctorContact) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var result = await DatabaseHelper.instance.updateDoctorInformation(
        doctorContact);
    print("update result $result");
    completer.complete(result);
    return completer.future;
  }

  Future<dynamic> getDoctorsList(BuildContext context,
      bool isNetworkAvailable) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var localDataResponse = await getDoctorsListLocal();

    var isLocalDataFound = !(localDataResponse is APIError);
    //data found locally
    if (isLocalDataFound) {
      if (isNetworkAvailable) {
        _syncData();
      }
      hideLoader();
      completer.complete(localDataResponse);
      notifyListeners();
      return completer.future;
    }

    var response =
    await APIHandler.get(context: context, url: APIs.getContacts);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ContactsResponse homeResponse = new ContactsResponse.fromJson(response);
      for (var data in homeResponse.data) {
        try {
          var id = await DatabaseHelper.instance.insert(data);
          print(id);
        } catch (ex) {
          //print("insert errro ${ex.toString()}");
        }
      }
      completer.complete(homeResponse);
      notifyListeners();
      return completer.future;
    }
  }

  //syn data locally it should be update instead insert
  void _syncData() async {
    var response = await APIHandler.get(url: APIs.getContacts);
    hideLoader();
    if (!(response is APIError)) {
      ContactsResponse homeResponse = new ContactsResponse.fromJson(response);
      for (var data in homeResponse.data) {
        try {
          //update record here
          ///  var id = await DatabaseHelper.instance.insert(data);
          //print(id);
        } catch (ex) {
          //print("insert errro ${ex.toString()}");
        }
      }
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
