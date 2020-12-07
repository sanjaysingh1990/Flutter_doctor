import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/utils/widgets.dart';
import 'package:shimmer/shimmer.dart';

class NotificationShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                child: ListView.separated(
              itemBuilder: (context, index) {
                return ShimmerNotificationItem();
              },
              itemCount: 10,
              separatorBuilder: (context, index) {
                return Divider();
              },
            )),
          ],
        ),
      ),
    );
  }
}

class HeadingSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        width: 50,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[400],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 10,
                width: 50,
                color: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerNotificationItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200],
      highlightColor: Colors.grey[400],
      child: Padding(
        padding:
            const EdgeInsets.only(left: 8.0, right: 8.0, top: 6, bottom: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 10.0,
                        width: 80,
                        color: Colors.white,
                      ),
                      getVerticalSpace(5),
                      Container(
                        height: 6.0,
                        width: 50,
                        color: Colors.white,
                      ),
                      getVerticalSpace(5),
                      Container(
                        height: 18.0,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Center(
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
