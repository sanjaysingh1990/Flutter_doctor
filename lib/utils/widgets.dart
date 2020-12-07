import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/utils/AppColors.dart';
import 'package:image_picker/image_picker.dart';

import '../data_models/country.dart';

class PhoneAuthWidgets {
  static Widget getHeading({String text}) => Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.white),
      );
}

class SearchCountryTF extends StatelessWidget {
  final TextEditingController controller;

  const SearchCountryTF({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 2.0, right: 8.0),
      child: Card(
        child: TextFormField(
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search your country',
            contentPadding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String prefix;
  final VoidCallback callBackCountry;

  const PhoneNumberField(
      {Key key, this.controller, this.prefix, this.callBackCountry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            InkWell(
                onTap: () {
                  callBackCountry();
                },
                child: Text("  " + prefix + "  ",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.kGreen,
                    ))),
            SizedBox(width: 8.0),
            Expanded(
              child: TextFormField(
                style: TextStyle(color: AppColors.kYellow, fontSize: 18),
                controller: controller,
                autofocus: false,
                keyboardType: TextInputType.phone,
                key: Key('EnterPhone-TextFormField'),
                decoration: InputDecoration(
                    isDense: false,
                    border: InputBorder.none,
                    errorMaxLines: 1,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.clear();
                      },
                      icon: Icon(Icons.clear),
                    )),
              ),
            ),
          ],
        ),
        Container(height: 1, color: Colors.white),
      ],
    );
  }
}

class SubTitle extends StatelessWidget {
  final String text;

  const SubTitle({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(' $text',
            style: TextStyle(color: Colors.white, fontSize: 14.0)));
  }
}

class ShowSelectedCountry extends StatelessWidget {
  final VoidCallback onPressed;
  final Country country;

  const ShowSelectedCountry({Key key, this.onPressed, this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(child: Text(' ${country.flag}  ${country.name} ')),
            Icon(Icons.arrow_drop_down, size: 24.0)
          ],
        ),
      ),
    );
  }
}

class SelectableWidget extends StatelessWidget {
  final Function(Country) selectThisCountry;
  final Country country;

  const SelectableWidget({Key key, this.selectThisCountry, this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      type: MaterialType.canvas,
      child: InkWell(
        onTap: () => selectThisCountry(country), //selectThisCountry(country),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "  " +
                country.flag +
                "  " +
                country.name +
                " (" +
                country.dialCode +
                ")",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

Widget getVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

Widget getButton({String text, VoidCallback callback}) {
  return RaisedButton(
    elevation: 2.0,
    onPressed: callback,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: TextStyle(color: AppColors.kWhite, fontSize: 18.0),
      ),
    ),
    color: AppColors.kGreen,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  );
}

Widget backButton(VoidCallback callback) {
  return InkWell(
    onTap: () {
      callback();
    },
    child: Icon(
      getPlatformSpecificBackIcon(),
      color: AppColors.kYellow,
    ),
  );
}

// Returns platform specific back button icon
IconData getPlatformSpecificBackIcon() {
  return defaultTargetPlatform == TargetPlatform.iOS
      ? Icons.arrow_back_ios
      : Icons.arrow_back;
}

//cached Network image
Widget getCachedNetworkImage(
    {@required String url, BoxFit fit, height, width}) {
  print(url);
  return new CachedNetworkImage(
    width: width ?? double.infinity,
    height: height ?? double.infinity,
    imageUrl: url ?? "",
    matchTextDirection: true,
    fit: fit,
    placeholder: (context, String val) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: new Center(
          child: new CupertinoActivityIndicator(),
        ),
      );
    },
    errorWidget: (BuildContext context, String error, Object obj) {
      return new Center(
          child: Icon(
        Icons.image,
        color: Colors.grey,
        size: 36.0,
      ));
    },
  );
}

Widget doctorImage(String url) {
  return Container(
    width: 60.0,
    height: 60.0,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: getCachedNetworkImage(
        fit: BoxFit.cover,
        url: url,
      ),
    ),
  );
}

Widget doctorImageLocal(PickedFile _imageFile) {
  return Container(
    width: 60.0,
    height: 60.0,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Image.file(File(_imageFile.path)),
    ),
  );
}
