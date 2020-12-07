import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/model/apierror.dart';
import 'package:flutter_app_test/model/doctorcontact.dart';
import 'package:flutter_app_test/providers/home_view_model.dart';
import 'package:flutter_app_test/shimmer/notification_shimmer.dart';
import 'package:flutter_app_test/utils/AppColors.dart';
import 'package:flutter_app_test/utils/AssetStrings.dart';
import 'package:flutter_app_test/utils/widgets.dart';

import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class DoctorDetailsPage extends StatefulWidget {
  final DoctorContact doctorContact;

  DoctorDetailsPage({this.doctorContact});

  _DoctorDetailsPageState createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  HomeViewModel _homeViewModel;
  var _notificationList = List<dynamic>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  var _isEditMode = false;
  double _width;

  String _day = "";
  String _month = "";
  String _year = "";


  //for image width and height
  double _maxWidth = 500;
  double _maxHeight = 500;

  //for picking media
  PickedFile _imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  fetchData();
    setData();
  }

  void setData() async{
    await Future.delayed(Duration(milliseconds: 300));
    _firstNameController.text = widget.doctorContact.firstName;
    _lastNameController.text = widget.doctorContact.lastName;
    _contactController.text = widget.doctorContact.primaryContactNo;
    _genderController.text = "";
    var dob=widget.doctorContact.dob;

    if(dob!=null)
      {
        var splitData=dob.split("/");
        _day=splitData[0];
        _month=splitData[1];
        _year=splitData[2];
      }
    setState(() {

    });
  }

//  void fetchData() async {
//    await Future.delayed(Duration(milliseconds: 500));
//    _notificationList.clear();
//    _homeViewModel.setLoading();
//    var response = await _homeViewModel.getDoctorsList(context);
//    if (response is APIError) {
//    } else {
//      _notificationList.addAll(response.data);
//    }
//  }

  VoidCallback callback() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.height;

    _homeViewModel = Provider.of<HomeViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.kPrimary,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10),
              child: backButton(callback),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Container(
                width: double.infinity,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0)),
                  color: Colors.white,
                ),
                child: _getUserInfoWidget(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                  height: 100,
                  child: Center(
                      child: InkWell(
                          onTap: () {
                            showActionSheet();
                          },
                          child: (_imageFile == null)
                              ? doctorImage(widget.doctorContact.profilePic)
                              : doctorImageLocal(_imageFile)))),
            ),
          ],
        ),
      ),
    );
  }

  void editProfile() async {
    if (_isEditMode) {
      //update data locally
      _updateData();
    }
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _updateData() async {
    _homeViewModel.getLoading();
    widget.doctorContact.firstName = _firstNameController.text;
    widget.doctorContact.lastName = _lastNameController.text;
    widget.doctorContact.dob="$_day/$_month/$_year";
    _homeViewModel.updateDoctorInformation(widget.doctorContact);
  }

  Widget _getTopWidget() => Container(
        color: AppColors.kWhite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVerticalSpace(40),
            Center(
                child: Text(
              "Doctor Name",
              style: TextStyle(fontSize: 16),
            )),
            Center(
              child: _getEditProfileButton(),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      );

  Widget _getUserInfoWidget() => Container(
        color: Colors.blueGrey.withOpacity(0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getTopWidget(),
            getVerticalSpace(10),
            Center(
                child: Text(
              "PERSONAL DETAILS",
              style: TextStyle(fontSize: 20),
            )),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getVerticalSpace(10),
                    _getInfoFieldWidget("FIRST NAME", _firstNameController,
                        isEditable: _isEditMode),
                    getVerticalSpace(10),
                    _getInfoFieldWidget("LAST NAME", _lastNameController,
                        isEditable: _isEditMode),
                    getVerticalSpace(10),
                    _getInfoFieldWidget("GENDER", _genderController),
                    getVerticalSpace(10),
                    _getInfoFieldWidget("CONTACT NUMBER", _contactController,
                        isEditable: false),
                    getVerticalSpace(20),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("DATE OF BIRTH",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.withOpacity(0.5))),
                    ),
                    getVerticalSpace(5),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        _getBox(
                            icon: Icons.calendar_today,
                            text: "$_day",
                            label: "DAY"),
                        SizedBox(
                          width: 10,
                        ),
                        _getBox(
                            icon: Icons.calendar_today,
                            text: "$_month",
                            label: "MONTH"),
                        SizedBox(
                          width: 10,
                        ),
                        _getBox(
                            icon: Icons.calendar_today,
                            text: "$_year",
                            label: "YEAR"),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    getVerticalSpace(20),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        _getBox(
                            icon: Icons.calendar_today,
                            text: "O+",
                            label: "BLOOD GROUP"),
                        SizedBox(
                          width: 10,
                        ),
                        _getBox(
                            icon: Icons.calendar_today,
                            text: "170cm",
                            label: "HEIGHT"),
                        SizedBox(
                          width: 10,
                        ),
                        _getBox(
                            icon: Icons.calendar_today,
                            text: "80kg",
                            label: "WEIGHT"),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    getVerticalSpace(20),
                  ],
                ),
              ),
            )
          ],
        ),
      );

  Widget _getInfoFieldWidget(
          String label, final TextEditingController controller,
          {bool isEditable = false}) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                TextFormField(
                  enabled: isEditable,
                  style: TextStyle(color: AppColors.kBlack, fontSize: 16),
                  controller: controller,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  key: Key('EnterPhone-TextFormField'),
                  decoration: InputDecoration(
                    isDense: false,
                    border: InputBorder.none,
                    errorMaxLines: 1,
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget _getEditProfileButton() => RaisedButton(
        onPressed: editProfile,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            (_isEditMode) ? "Save" : "Edit Profile",
            style: TextStyle(color: AppColors.kWhite, fontSize: 12.0),
          ),
        ),
        color: AppColors.kGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      );

  Widget _getBox({IconData icon, String text, String label}) => Expanded(
        child: InkWell(
          onTap: () {
            if (label == "DAY" || label == "MONTH" || label == "YEAR") {
              _showDatePicker();
            }
          },
          child: Container(
              color: AppColors.kWhite,
              height: _width * 0.12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        label,
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  getVerticalSpace(
                    5,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kBlack),
                  )
                ],
              )),
        ),
      );

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }

      setState(() {
        _day = pickedDate.day.toString();
        _month = pickedDate.month.toString();
        _year = pickedDate.year.toString();
      });
    });
  }

  void showActionSheet() {
    final act = CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              _closeActionSheet();
              _onImageButtonPressed(ImageSource.camera, context: context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Gallery'),
            onPressed: () {
              _closeActionSheet();

              _onImageButtonPressed(ImageSource.gallery, context: context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () {
            _closeActionSheet();
          },
        ));
    showCupertinoModalPopup(
        context: context, builder: (BuildContext context) => act);
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
//    if (_controller != null) {
//      await _controller.setVolume(0.0);
//    }

    try {
      final pickedFile = await ImagePicker().getImage(
        source: source,
        maxWidth: _maxWidth,
        maxHeight: _maxHeight,
        imageQuality: 100,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
//              setState(() {
//                _pickImageError = e;
//              });
    }
  }

  void _closeActionSheet() {
    Navigator.of(context, rootNavigator: true).pop("Discard");
  }
}

class Heading extends StatelessWidget {
  final String heading;

  Heading({@required this.heading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            heading,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

class DoctorItemWidget extends StatelessWidget {
  final DoctorContact doctorContact;
  final VoidCallback changeImage;

  DoctorItemWidget({@required this.doctorContact, @required this.changeImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6, bottom: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    changeImage();
                  },
                  child: doctorImage(doctorContact.profilePic)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${doctorContact.firstName} ${doctorContact.lastName}",
                      style: TextStyle(
                          //fontFamily: AssetStrings.giloryExteraBoldStyle,
                          color: Colors.blue,
                          fontSize: 16)),
                  getVerticalSpace(5),
                  Text("${doctorContact.specialization.toUpperCase()}",
                      style: TextStyle(
                          //fontFamily: AssetStrings.giloryExteraBoldStyle,
                          color: Colors.blue,
                          fontSize: 14)),
                  getVerticalSpace(5),
                  Text(
                    "${doctorContact.description}",
                    style: TextStyle(
                        //fontFamily: AssetStrings.giloryExteraBoldStyle,
                        fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              )),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.navigate_next,
                color: Colors.black,
                size: 24.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget doctorImage(String url) {
    return Container(
      width: 50.0,
      height: 50.0,
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
}
