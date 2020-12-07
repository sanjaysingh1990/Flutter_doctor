import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/auth/phone_auth/verify.dart';

import 'package:flutter_app_test/providers/countries.dart';
import 'package:flutter_app_test/providers/phone_auth.dart';
import 'package:flutter_app_test/utils/AppColors.dart';
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



  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-get-phone");

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;

    final countriesProvider = Provider.of<CountryProvider>(context);
    final loader = Provider.of<PhoneAuthDataProvider>(context).loading;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: AppColors.kPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left:24.0,right: 24),
          child: Stack(
            children: <Widget>[
              _getBody(countriesProvider),
              loader ? Center(child: CircularProgressIndicator()) : SizedBox(),
              Positioned(bottom: _height * 0.15,left: 0,right: 0,child: getButton(text:"Continue",callback:startPhoneAuth ),)
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody(CountryProvider countriesProvider) => Container(
    child: countriesProvider.countries.length > 0
        ? _getColumnBody(countriesProvider)
        : Center(child: CircularProgressIndicator()),
  );

  //move to select country screen
  VoidCallback callBackSelectCountry() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SelectCountry()));
  }



  Widget _getColumnBody(CountryProvider countriesProvider) => Column(
        children: <Widget>[
          getVerticalSpace(_height * 0.15),
          PhoneAuthWidgets.getHeading(
              text: ResString().get("enterphoneheading")),
          getVerticalSpace(20),
          PhoneNumberField(
            controller:
                Provider.of<PhoneAuthDataProvider>(context, listen: false)
                    .phoneNumberController,
            prefix: countriesProvider.selectedCountry.dialCode ?? "+91",
            callBackCountry: callBackSelectCountry,
          ),
          getVerticalSpace(16),
          Text(ResString().get("enterphonedesc"),
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w400)),

        ],
      );

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
    );

    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  startPhoneAuth() async {
    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);
    phoneAuthDataProvider.loading = true;
    var countryProvider = Provider.of<CountryProvider>(context, listen: false);
    bool validPhone = await phoneAuthDataProvider.instantiate(
        dialCode: countryProvider.selectedCountry.dialCode,
        onCodeSent: () {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => PhoneAuthVerify()));
        },
        onFailed: () {
          _showSnackBar(phoneAuthDataProvider.message);
        },
        onError: () {
          _showSnackBar(phoneAuthDataProvider.message);
        });
    if (!validPhone) {
      phoneAuthDataProvider.loading = false;
      _showSnackBar("Oops! Number seems invaild");
      return;
    }
  }
}
