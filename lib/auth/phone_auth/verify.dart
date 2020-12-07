import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/doctor/doctorpage.dart';

import 'package:flutter_app_test/privacypolicy/webview_page.dart';
import 'package:flutter_app_test/providers/phone_auth.dart';
import 'package:flutter_app_test/utils/AppColors.dart';
import 'package:flutter_app_test/utils/class%20ResString.dart';
import 'package:flutter_app_test/utils/constants.dart';
import 'package:flutter_app_test/utils/widgets.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:provider/provider.dart';

class PhoneAuthVerify extends StatefulWidget {
  final String phoneNo;
  PhoneAuthVerify({@required this.phoneNo});

  @override
  _PhoneAuthVerifyState createState() => _PhoneAuthVerifyState();
}

class _PhoneAuthVerifyState extends State<PhoneAuthVerify> {
  double _height;

  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType> errorController;
  var onTapRecognizer;
  bool hasError = false;
  String currentText = "";
  bool checkBoxValue = false;

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-verify-phone");

  @override
  Widget build(BuildContext context) {
    print(widget.phoneNo);
    //  Fetching height & width parameters from the MediaQuery
    //  _logoPadding will be a constant, scaling it according to device's size
    _height = MediaQuery.of(context).size.height;

    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);

    phoneAuthDataProvider.setMethods(
      onStarted: onStarted,
      onError: onError,
      onFailed: onFailed,
      onVerified: onVerified,
      onCodeResent: onCodeResent,
      onCodeSent: onCodeSent,
      onAutoRetrievalTimeout: onAutoRetrievalTimeOut,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: AppColors.kPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24),
          child: Stack(
            children: [
              _getColumnBody(),
              Positioned(
                bottom: _height * 0.15,
                left: 0,
                right: 0,
                child: _getBottomWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBottomWidget() => Column(
        children: [
          Container(
              width: double.infinity,
              child: getButton(text: "Login", callback: signIn)),
          getVerticalSpace(20),
          Row(
            children: [
              SizedBox(
                height: 24.0,
                width: 24.0,
                child: new Checkbox(
                    value: checkBoxValue,
                    activeColor: Colors.green,
                    onChanged: (bool newValue) {
                      setState(() {
                        checkBoxValue = newValue;
                      });
                    }),
              ),
              SizedBox(
                width: 10,
              ),
              new RichText(
                  textAlign: TextAlign.center,
                  text: new TextSpan(
                    text: "I agree to the ",
                    children: <TextSpan>[
                      new TextSpan(
                        text: "Terms of Use",
                        style: TextStyle(color: AppColors.kYellow),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            print("called");
                            _redirect(
                                heading: ResString().get('term_of_uses'),
                                url: Constants.TermOfUses);
                          },
                      ),
                      new TextSpan(
                        text: " and ",
                        // style: TextThemes.grayNormalSmall,
                      ),
                      new TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(color: AppColors.kYellow),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            _redirect(
                                heading: ResString().get('privacy_policy'),
                                url: Constants.privacyPolicy);
                          },
                      ),
                    ],
                  )),
            ],
          ),
        ],
      );

  _redirect({@required String heading, @required String url}) async {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new WebViewPages(
                  heading: heading,
                  url: url,
                )));
  }

  Widget _getColumnBody() => Column(
        children: <Widget>[
          //  Logo: scaling to occupy 2 parts of 10 in the whole height of device
          getVerticalSpace(_height * 0.15),
          PhoneAuthWidgets.getHeading(
              text: ResString().get("enter_code")),
          getVerticalSpace(20),

          PinCodeTextField(
            appContext: context,
            length: 6,
            obscureText: false,
            animationType: AnimationType.fade,
            textStyle: TextStyle(color: AppColors.kYellow, fontSize: 20),
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(0),
                fieldHeight: 50,
                fieldWidth: 50,
                activeFillColor: Colors.black.withOpacity(0.3),
                inactiveFillColor: Colors.black.withOpacity(0.3),
                activeColor: Colors.black.withOpacity(0.3),
                borderWidth: 0),
            animationDuration: Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            enableActiveFill: true,
            errorAnimationController: errorController,
            controller: textEditingController,
            onCompleted: (v) {
              print("Completed");
            },
            onChanged: (value) {
              print(value);
              setState(() {
                currentText = value;
              });
            },
            beforeTextPaste: (text) {
              print("Allowing to paste $text");
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
          ),

          Text(ResString().get("verify_otp")+" ${widget.phoneNo}",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
        ],
      );

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
      duration: Duration(seconds: 2),
    );
//    if (mounted) Scaffold.of(context).showSnackBar(snackBar);
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  signIn() {
    var code = textEditingController.text;
    if (code.length != 6) {
      _showSnackBar("Invalid OTP");
    }
    Provider.of<PhoneAuthDataProvider>(context, listen: false)
        .verifyOTPAndLogin(smsCode: code);
  }

  onStarted() {
    _showSnackBar("PhoneAuth started");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onCodeSent() {
    _showSnackBar("OPT sent");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onCodeResent() {
    _showSnackBar("OPT resent");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onVerified() async {
    _showSnackBar(
        "${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => DoctorPage()));
  }

  onFailed() {
//    _showSnackBar(phoneAuthDataProvider.message);
    _showSnackBar("PhoneAuth failed");
  }

  onError() {
//    _showSnackBar(phoneAuthDataProvider.message);
    _showSnackBar(
        "PhoneAuth error ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
  }

  onAutoRetrievalTimeOut() {
    _showSnackBar("PhoneAuth autoretrieval timeout");
//    _showSnackBar(phoneAuthDataProvider.message);
  }
}
