import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:team_management_software/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sizer/sizer.dart';
import 'package:team_management_software/controller/http_functions.dart';
import 'package:team_management_software/controller/shared_prefernce_functions.dart';
import 'package:team_management_software/views/home_screen.dart';
import 'package:team_management_software/views/screens/bottom_navigation.dart';
import 'package:team_management_software/views/sign_up.dart';
import 'package:team_management_software/views/user_sign_up.dart';
import 'package:team_management_software/views/welcome_screen.dart';


class SignInPage extends StatefulWidget {
  String role;
  SignInPage({required this.role});
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  SharedPreferencesFunctions sharedPreferencesFunctions=SharedPreferencesFunctions();
  Constants constants=Constants();

  bool showSpinner = false;
 // TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  validateAndSignIn() async {
    setState(() {
      showSpinner = true;
    });
    var form = formKey.currentState?.validate();
    if (form!) {
      HttpFunctions httpFunctions=HttpFunctions();
   String signInResponse=await httpFunctions.signInUser(username: userNameController.text,password: passwordController.text,role: widget.role);
   var finalData=jsonDecode(signInResponse);
   if(finalData["status"]=="true"){
     final snackBar = SnackBar(content: Text("Sign in successful"),duration: Duration(milliseconds: 500),);
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
     SharedPreferencesFunctions.setIsUserLoggedIn(true);
     SharedPreferencesFunctions.saveUserName(userNameController.text);
     Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavigation()));
   }else{
     final snackBar = SnackBar(content: Text("Invalid credentials"),duration: Duration(milliseconds: 1000),);
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }
      // final snackBar = SnackBar(content: Text("Sign in successful"),duration: Duration(milliseconds: 500),);
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavigation()));
    }

    setState(() {
      showSpinner = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
          body: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding:  EdgeInsets.fromLTRB(12.sp, 80.sp, 0.0, 0.0),
                      child:  Text(
                        'SignIn',
                        style:
                        TextStyle(fontSize: 60.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(200.sp, 75.sp, 0.0, 0.0),
                      child:  Text(
                        '.',
                        style: TextStyle(
                            fontSize: 60.sp,
                            fontWeight: FontWeight.bold,
                            color:Constants.buttonColor),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  padding:  EdgeInsets.only(top: 30.sp, left: 20.sp, right: 20.sp),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: userNameController,
                          validator: (val) {
                            val ??= " ";
                            return val.length >= 4 ? null : " Enter a valid email";
                          },
                          decoration: Constants.kTextFormFieldDecoration("USERNAME"),
                        ),
                         SizedBox(height: 1.h),
                        TextFormField(
                          controller: passwordController,
                          validator: (val) {
                            val ??= "";
                            return val.length >= 6 ? null : "Enter a valid password";
                          },
                          decoration: Constants.kTextFormFieldDecoration("PASSWORD"),
                          obscureText: true,
                        ),
                         SizedBox(height: 5.h),
                        GestureDetector(
                          onTap: (){
                            validateAndSignIn();
                          },
                          child: Container(
                              height: 6.2.h,
                              child: Material(
                                borderRadius: BorderRadius.circular(11.sp),
                                shadowColor: Colors.yellowAccent,
                                color: Constants.buttonColor,
                              //  Colors.green,
                                elevation: 7.0,
                                child:  Center(
                                  child: Text(
                                    'SIGN IN',
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              )),
                        ),
                         SizedBox(height: 2.4.h),
                        Container(
                          height: 6.2.h,
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.0),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(11.sp)),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                  return widget.role=="admin"?SignUpPage():UserSignUp();
                                }));
                              },
                              child:
                               Center(
                                child: Text('Don\'t have an account? SignUp',
                                    style: TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat')),
                              ),


                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                      ],
                    ),
                  )),
            ]),
          )),
    );
  }
}