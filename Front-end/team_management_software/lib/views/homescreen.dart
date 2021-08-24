import 'package:flutter/material.dart';
import 'package:team_management_software/views/sign_in.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        // width: double.infinity,
        // height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 40.sp, vertical: 50.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(children: <Widget>[
              Text(
                "Welcome",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.sp),
              ),
            ]),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage("images/LOGO2.png"))),
            ),
            Column(
              children: <Widget>[
                // Container(
                //     height: 6.2.h,
                //     child: Material(
                //       borderRadius: BorderRadius.circular(11.sp),
                //       shadowColor: Colors.greenAccent,
                //       color: Colors.green,
                //       elevation: 7.0,
                //       child:  Center(
                //         child: Text(
                //           'SIGN IN',
                //           style: TextStyle(
                //               fontSize: 9.sp,
                //               color: Colors.white,
                //               fontWeight: FontWeight.bold,
                //               fontFamily: 'Montserrat'),
                //         ),
                //       ),
                //     )),
                MaterialButton(
                  color: Constants.buttonColor
                  ,
                  elevation: 6,
                  minWidth: double.infinity,
                  height: 7.h,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(14.sp)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));
                  },
                  child: Text(
                    "SIGN IN",
                    style: TextStyle(color: Colors.black,
                        fontWeight: FontWeight.bold, fontSize: 13.sp),
                  ),
                ),
                SizedBox(height: 3.h),
                Container(
                  child: MaterialButton(
                    color: Colors.white,
                    elevation: 2,
                    minWidth: double.infinity,
                    height: 7.h,

                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(14.sp)),
                    onPressed: () {},
                    child: Text(
                      "SIGN UP",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
