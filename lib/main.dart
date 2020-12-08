import 'package:flutter/material.dart';
import 'package:flutter_app_test/pages/auth/phone_auth/get_phone.dart';

import 'package:flutter_app_test/providers/countries.dart';
import 'package:flutter_app_test/providers/home_view_model.dart';
import 'package:flutter_app_test/providers/phone_auth.dart';

import 'package:provider/provider.dart';

import 'pages/doctor/doctorpage.dart';





void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CountryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PhoneAuthDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(),
        ),
      ],
      child: MaterialApp(
        home: PhoneAuthGetPhone(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
