import 'package:flutter/material.dart';
import 'package:team_management_software/controller/http_functions.dart';
import 'package:team_management_software/views/sign_in.dart';
import 'package:sizer/sizer.dart';
import 'package:team_management_software/views/admin_sign_up.dart';
import 'package:team_management_software/views/user_sign_up.dart';
import '../constants.dart';

class WelcomeScreen extends StatelessWidget {

  Future<void> _dialogToChooseRole(context,bool isSignUp) async {

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //actionsAlignment: MainAxisAlignment.center,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Please Select Role"),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListBody(
                    children:  <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                              isSignUp?AdminSignUp():SignInPage(role:"admin") ));
                       //   Navigator.pop(context);
                        },
                        child:Container(
                          padding:EdgeInsets.only(bottom: 5),
                          child:Constants.kWidgetForStatusAndPriority(isSignUp?"Admin Sign Up":"Admin Sign In", Colors.green[200]),
                        )
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                              isSignUp?UserSignUp():SignInPage(role:"user") ));
                         // Navigator.pop(context);
                        },
                        child:  Constants.kWidgetForStatusAndPriority(isSignUp?"User Sign Up":"User Sign In",  Constants.buttonColor,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }



   WelcomeScreen({Key? key}) : super(key: key);
 final HttpFunctions httpFunctions=HttpFunctions();
  @override
  build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
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
                height: 45.h,
                decoration: const BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage("images/LOGO2.png"))),
              ),
              Column(
                children: <Widget>[

                  MaterialButton(
                    color: Constants.buttonColor
                    ,
                    elevation: 7,
                    minWidth: double.infinity,
                    height: 7.h,
                    shape: RoundedRectangleBorder(
                       // side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(14.sp)),
                    onPressed: () async {
                      // var response= await  httpFunctions.signInUser();
                      // print("response from welcome screen $response");
                     _dialogToChooseRole(context, false);
                    },
                    child: Text(
                      "SIGN IN",
                      style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold, fontSize: 13.sp),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  MaterialButton(
                    color: Colors.white,
                    elevation: 2,
                    minWidth: double.infinity,
                    height: 7.h,

                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(14.sp)),
                    onPressed: () {
                      _dialogToChooseRole(context,true);

                      // httpFunctions.registerUser(
                      // );
                    },
                    child: Text(
                      "SIGN UP",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                    ),
                  )
                ],
              )
            ],
          ),
      ),
    ),
        ));
  }
}
