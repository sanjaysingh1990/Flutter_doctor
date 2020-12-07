import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/auth/phone_auth/verify.dart';

import 'package:flutter_app_test/providers/countries.dart';
import 'package:flutter_app_test/providers/phone_auth.dart';
import 'package:flutter_app_test/utils/AppColors.dart';
import 'package:flutter_app_test/utils/AssetStrings.dart';
import 'package:flutter_app_test/utils/class%20ResString.dart';
import 'package:flutter_app_test/utils/constants.dart';
import 'package:flutter_app_test/utils/widgets.dart';

import 'package:provider/provider.dart';

import 'select_country.dart';

/*
 *  PhoneAuthUI - this file contains whole ui and controllers of ui
 *  Background code will be in other class
 *  This code can be easily re-usable with any other service type, as UI part and background handling are completely from different sources
 *  code.dart - Class to control background processes in phone auth verification using Firebase
 */

class PhoneAuthGetPhone extends StatefulWidget {
  @override
  _PhoneAuthGetPhoneState createState() => _PhoneAuthGetPhoneState();
}

class _PhoneAuthGetPhoneState extends State<PhoneAuthGetPhone> {
  double _height;
  var countriesProvider;
   PhoneAuthDataProvider phoneAuthProvider;

  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-get-phone");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 // _setListener();
  }


  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    phoneAuthProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);
    countriesProvider = Provider.of<CountryProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: AppColors.kPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24),
          child: Stack(
            children: <Widget>[
              _getBody(),
              Positioned(
                bottom: _height * 0.15,
                left: 0,
                right: 0,
                child: getButton(text: "Continue", callback: startPhoneAuth),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody() => Container(
        child: countriesProvider.countries.length > 0
            ? _getColumnBody()
            : Center(child: CircularProgressIndicator()),
      );

  //move to select country screen
  VoidCallback callBackSelectCountry() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SelectCountry()));
  }

  Widget _getColumnBody() => Column(
        children: <Widget>[
          getVerticalSpace(_height * 0.15),
          PhoneAuthWidgets.getHeading(
              text: ResString().get("enterphoneheading")),
          getVerticalSpace(20),
          PhoneNumberField(
            controller: phoneAuthProvider.phoneNumberController,
            prefix: countriesProvider.selectedCountry.dialCode ?? "+91",
            callBackCountry: callBackSelectCountry,
          ),
          getVerticalSpace(16),
          Text(ResString().get("enterphonedesc"),
              style: TextStyle(
                  color: Colors.white, fontFamily: AssetStrings.robotoRegular)),
        ],
      );

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
    );

    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  startPhoneAuth() async {
    var phoneNo=phoneAuthProvider.phoneNumberController.text;
    var countryCode= countriesProvider.selectedCountry.dialCode ?? "+91";

    var finalPhoneNo = "$countryCode $phoneNo";

    phoneAuthProvider.loading = true;
    var countryProvider = Provider.of<CountryProvider>(context, listen: false);
    bool validPhone = await phoneAuthProvider.instantiate(
        dialCode: countryProvider.selectedCountry.dialCode,
        onCodeSent: () {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => PhoneAuthVerify(
                    phoneNo: finalPhoneNo,
                  )));
        },
        onFailed: () {
          _showSnackBar(phoneAuthProvider.message);
        },
        onError: () {
          _showSnackBar(phoneAuthProvider.message);
        });
    if (!validPhone) {
      phoneAuthProvider.loading = false;
      _showSnackBar("Oops! Number seems invaild");
      return;
    }
  }
}
