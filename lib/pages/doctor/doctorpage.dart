import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app_test/localdb/DatabaseHelper.dart';
import 'package:flutter_app_test/model/apierror.dart';
import 'package:flutter_app_test/model/doctorcontact.dart';
import 'package:flutter_app_test/pages/doctordetails/doctordetailspage.dart';
import 'package:flutter_app_test/providers/home_view_model.dart';
import 'package:flutter_app_test/shimmer/notification_shimmer.dart';
import 'package:flutter_app_test/utils/AppColors.dart';
import 'package:flutter_app_test/utils/AssetStrings.dart';
import 'package:flutter_app_test/utils/Messages.dart';
import 'package:flutter_app_test/utils/widgets.dart';

import 'package:provider/provider.dart';

class DoctorPage extends StatefulWidget {
  DoctorPage({Key key}) : super(key: key);

  _DoctorPagePageState createState() => _DoctorPagePageState();
}

class _DoctorPagePageState extends State<DoctorPage> {
  HomeViewModel _homeViewModel;
  var _doctorsList = List<DoctorContact>();
  final scaffoldKey =
  GlobalKey<ScaffoldState>(debugLabel: "pages.doctor-page");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await Future.delayed(Duration(milliseconds: 500));
    _homeViewModel.setLoading();
    //check internet conneciton first
    bool isNetworkAvaialble = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
       _showSnackBar(Messages.noInternetError);
      },
      onSuccess: () {},
    );


    _doctorsList.clear();

    var response = await _homeViewModel.getDoctorsList(context,isNetworkAvaialble);
    if (response is APIError) {
      _showSnackBar(response.message??Messages.genericError);
    } else {

      _doctorsList.addAll(response.data);
      _doctorsList.sort((doctor1, doctor2) => doctor2.rating.compareTo(doctor1.rating)); //sort list by max rating at top
    }
  }

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
      duration: Duration(seconds: 2),
    );
//    if (mounted) Scaffold.of(context).showSnackBar(snackBar);
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  VoidCallback updateCallBack()
  {
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    _homeViewModel = Provider.of<HomeViewModel>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.kWhite,
        title: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        Image.asset(AssetStrings.logo1,width: 100,height: 120,),
        Image.asset(AssetStrings.logo,width: 100,height: 120),

      ],),),
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: ListView.separated(
              itemCount: _doctorsList.length,
              itemBuilder: (context, index) {
                var data=_doctorsList[index];
                return InkWell(
                  onTap: (){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) => DoctorDetailsPage(doctorContact: data,callBackUpdate: updateCallBack,)));
                  },
                  child: DoctorItemWidget(
                      doctorContact: data),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
          Visibility(
            child: NotificationShimmer(),
            visible: _homeViewModel.getLoading(),
          )
        ],
      ),
    );
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

  DoctorItemWidget({@required this.doctorContact});

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
              doctorImage(doctorContact.profilePic,50),
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
                          fontSize: 16,fontFamily: AssetStrings.robotoBold)),
                  getVerticalSpace(5),
                  Text("${doctorContact.specialization.toUpperCase()}",
                      style: TextStyle(
                          //fontFamily: AssetStrings.giloryExteraBoldStyle,
                          color: Colors.blue,
                          fontSize: 14,fontFamily: AssetStrings.robotoRegular)),
                  getVerticalSpace(5),
                  Text(
                    "${doctorContact.description}",
                    style: TextStyle(
                        //fontFamily: AssetStrings.giloryExteraBoldStyle,
                        fontSize: 12,fontFamily: AssetStrings.robotoRegular),
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


}
