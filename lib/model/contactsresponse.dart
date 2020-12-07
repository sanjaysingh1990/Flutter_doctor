import 'package:flutter_app_test/model/doctorcontact.dart';

class ContactsResponse {
 List<DoctorContact> data;

  ContactsResponse(
      {this.data});

  ContactsResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      data = new List<DoctorContact>();
      json.forEach((v) {
        data.add(new DoctorContact.fromJson(v));
      });
    }
  }


}