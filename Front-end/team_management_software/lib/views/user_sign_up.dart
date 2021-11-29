import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:team_management_software/controller/http_functions.dart';
import 'package:team_management_software/controller/shared_prefernce_functions.dart';
import 'package:team_management_software/views/chat_section/push_notification.dart';
import 'package:team_management_software/views/components/role_dropdown.dart';
import 'package:team_management_software/views/project_list_screen.dart';
import 'package:team_management_software/views/screens/bottom_navigation.dart';
import 'package:team_management_software/views/sign_in.dart';
import 'package:sizer/sizer.dart';
import '../constants.dart';
import 'home_screen.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({Key? key}) : super(key: key);

  @override
  _UserSignUpState createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  bool isLoading=false;

  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController idController = TextEditingController();

  var error = [false, false];
  errorInForm(index) {
    setState(() {
      error[index] = true;
    });
  }
var token="";
  getDeviceToken()async{
    FirebaseNotification firebaseNotification=FirebaseNotification();
     token= await firebaseNotification.getToken();
  }

  @override
  void initState() {
   getDeviceToken();
    super.initState();
  }


  final formKey = GlobalKey<FormState>();

  validateAndSignUp() async{
    setState(() {
      isLoading=true;
    });
    var form = formKey.currentState?.validate();
    if (form!) {
      HttpFunctions httpFunctions = HttpFunctions();
      bool signUpResponse=await  httpFunctions.registerNewUser(
          name: nameController.text,
          username: usernameController.text,
          password: passwordController.text,
          passwordConfirm: confirmPasswordController.text,
          email: emailController.text,
          designation: designationController.text,
          token: token,
          companyId:idController.text
          //todo token
      );

      if(signUpResponse){
        const snackBar =   SnackBar(content: Text("Sign Up successful"),duration: Duration(milliseconds: 500),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        SharedPreferencesFunctions.setIsUserLoggedIn(true);
        SharedPreferencesFunctions.saveUserName(nameController.text);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavigation()));
      }else{
        const snackBar = SnackBar(content: Text("Unable to sign up"),duration: Duration(milliseconds: 1000),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    setState(() {
      isLoading=false;
    });
  }

  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
          body: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(12.sp, 40.sp, 0.0, 0.0),
                      child: Text(
                        'Signup',
                        style:
                        TextStyle(fontSize: 60.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(210.sp, 45.sp, 0.0, 0.0),
                      child: Text(
                        '.',
                        style: TextStyle(
                            fontSize: 60.sp,
                            fontWeight: FontWeight.bold,
                            color: Constants.buttonColor),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5.sp, left: 20.sp, right: 20.sp),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Stepper(
                        controlsBuilder: (BuildContext context,
                            {VoidCallback? onStepContinue,
                              VoidCallback? onStepCancel}) {
                          return Row(
                            children: <Widget>[
                              _index != 1
                                  ? TextButton(
                                onPressed: onStepContinue,
                                child: Text(
                                  'Next',
                                  style:
                                  TextStyle(color: Constants.buttonColor),
                                ),
                              )
                                  : Container(),
                              _index != 0
                                  ? TextButton(
                                onPressed: onStepCancel,
                                child: Text(
                                  'Previous',
                                  style:
                                  TextStyle(color: Constants.buttonColor),
                                ),
                              )
                                  : Container(),
                            ],
                          );
                        },
                        physics: const ClampingScrollPhysics(),
                        currentStep: _index,
                        onStepCancel: () {
                          if (_index > 0) {
                            setState(() {
                              _index -= 1;
                              setState(() {
                                error[_index] = false;
                              });
                            });
                          }
                        },
                        onStepContinue: () {
                          if (_index <= 0) {
                            setState(() {
                              _index += 1;
                              setState(() {
                                error[_index] = false;
                              });
                            });
                          }
                        },
                        onStepTapped: (int index) {
                          setState(() {
                            error[index] = false;
                            _index = index;
                          });
                        },
                        steps: <Step>[
                          Step(
                            title: Text(
                              'Personal Details',
                              style: TextStyle(
                                  color: error[0] ? Colors.red : Colors.black),
                            ),
                            content: Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: nameController,
                                    validator: (val) {
                                      val ??= " ";

                                      val.length >= 3 ? null : errorInForm(0);
                                      return val.length >= 3
                                          ? null
                                          : " Enter a valid name";
                                    },
                                    decoration:
                                    Constants.kTextFormFieldDecoration("NAME"),
                                  ),
                                  TextFormField(
                                    controller: emailController,
                                    validator: (val) {
                                      val ??= "";
                                      RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                          .hasMatch(val)
                                          ? null
                                          : errorInForm(0);
                                      return RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                          .hasMatch(val)
                                          ? null
                                          : "Invalid email";
                                    },
                                    decoration:
                                    Constants.kTextFormFieldDecoration("EMAIL"),
                                  ),

                                  TextFormField(
                                    controller: designationController,
                                    validator: (val) {
                                      val ??= " ";
                                      val.length >= 2 ? null : errorInForm(0);
                                      return val.length >= 2
                                          ? null
                                          : "Enter a valid company name";
                                    },
                                    decoration: Constants.kTextFormFieldDecoration(
                                        "DESIGNATION"),
                                  ),


                                ],
                              ),
                            ),
                          ),
                          Step(
                            title: Text(
                              'Final Activation',
                              style: TextStyle(
                                  color: error[1] ? Colors.red : Colors.black),
                            ),
                            content: Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: usernameController,
                                    validator: (val) {
                                      val ??= " ";

                                      val.length >= 3? null : errorInForm(1);
                                      return val.length >= 3
                                          ? null
                                          : " Enter a valid username";
                                    },
                                    decoration: Constants.kTextFormFieldDecoration(
                                        "USERNAME"),
                                  ),
                                  // SizedBox(height: 1.h),
                                  TextFormField(
                                    controller: passwordController,
                                    validator: (val) {
                                      val ??= "";
                                      val.length >= 6 ? null : errorInForm(1);
                                      return val.length >= 6
                                          ? null
                                          : "Enter a valid password greater than 6";
                                    },
                                    decoration: Constants.kTextFormFieldDecoration(
                                        "PASSWORD"),
                                    obscureText: true,
                                  ),
                                  TextFormField(
                                    controller: confirmPasswordController,
                                    validator: (val) {
                                      val ??= "";
                                      val.length >= 6 ? null : errorInForm(1);
                                      return val.length >= 6
                                          ? null
                                          : "Password do not match";
                                    },
                                    decoration: Constants.kTextFormFieldDecoration(
                                        "CONFIRM PASSWORD"),
                                    obscureText: true,
                                  ),
                                  // SizedBox(height: 1.h),
                                  TextFormField(
                                    controller: confirmPasswordController,
                                    validator: (val) {
                                      val ??= "";
                                      val.length >= 6 ? null : errorInForm(1);
                                      return val.length >= 2
                                          ? null
                                          : "Password do not match";
                                    },
                                    decoration: Constants.kTextFormFieldDecoration(
                                        "COMPANY ID"),
                                    obscureText: true,
                                  ),




                                ],
                              ))
                          )],
                      ),
                      //  SizedBox(height: 5.h),
                      GestureDetector(
                        onTap: () {
                          validateAndSignUp();
                         // print("proceeding to sign up ${error[0]}");
                        },
                        child: Container(
                            height: 6.2.h,
                            child: Material(
                              borderRadius: BorderRadius.circular(11.sp),
                              shadowColor: Colors.yellowAccent,
                              color: Constants.buttonColor,
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'SIGN UP',
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
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                    return SignInPage(role: "user",);
                                  }));
                            },
                            child: Center(
                              child: Text('Already have an account? SignIn',
                                  style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 3.4.h),
                    ],
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
