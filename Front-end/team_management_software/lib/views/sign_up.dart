import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:team_management_software/controller/http_functions.dart';
import 'package:team_management_software/controller/shared_prefernce_functions.dart';
import 'package:team_management_software/views/components/role_dropdown.dart';
import 'package:team_management_software/views/sign_in.dart';
import 'package:sizer/sizer.dart';
import '../constants.dart';
import 'home_screen.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading=false;
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyDescriptionController = TextEditingController();
  TextEditingController companyPhoneController = TextEditingController();
  TextEditingController companyEmailController = TextEditingController();
  TextEditingController activationCodeController = TextEditingController();
  String dropDownValue = "";

  var error = [false, false, false];
  errorInForm(index) {
    setState(() {
      error[index] = true;
    });
  }

  setStateFunction() {
    setState(() {});
  }

  final formKey = GlobalKey<FormState>();

  validateAndSignUp() async {

    setState(() {
      isLoading=true;
    });
    var form = formKey.currentState?.validate();
    if (form!) {

      HttpFunctions httpFunctions = HttpFunctions();
      String signUpResponse = await httpFunctions.registerNewAdmin(
          name: nameController.text,
          username: usernameController.text,
          password: passwordController.text,
          passwordConfirm: confirmPasswordController.text,
          email: emailController.text,
          phoneNumber: int.parse(phoneController.text),
          address: addressController.text,
          companyName: companyNameController.text,
          companyDescription: companyDescriptionController.text,
          companyEmail: companyEmailController.text,
          companyNumber: int.parse(companyPhoneController.text),
          activationToken: activationCodeController.text,
          role: dropDownValue);
      var finalData = jsonDecode(signUpResponse);


      if (finalData["status"] == "true") {
        const snackBar = SnackBar(
          content: Text("Sign Up successful"),
          duration: Duration(milliseconds: 500),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        SharedPreferencesFunctions.setIsUserLoggedIn(true);
        SharedPreferencesFunctions.saveUserName(usernameController.text);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
      else {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
        const snackBar = SnackBar(
          content: Text("Unable to sign up, check credentials"),
          duration: Duration(milliseconds: 1000),
        );
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
                          _index != 2
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
                      if (_index <= 1) {
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
                                      : " Enter a valid name ";
                                },
                                decoration:
                                    Constants.kTextFormFieldDecoration("NAME"),
                              ),
                              TextFormField(
                                controller: usernameController,
                                validator: (val) {
                                  val ??= " ";

                                  val.length >= 3 ? null : errorInForm(0);
                                  return val.length >= 3
                                      ? null
                                      : " Enter a valid username greater than 3";
                                },
                                decoration: Constants.kTextFormFieldDecoration(
                                    "USERNAME"),
                              ),
                              // SizedBox(height: 1.h),
                              TextFormField(
                                controller: passwordController,
                                validator: (val) {
                                  val ??= "";
                                  val.length >= 6 ? null : errorInForm(0);
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
                                  val.length >= 6 ? null : errorInForm(0);
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
                              // SizedBox(height: 1.h),
                              TextFormField(
                                controller: phoneController,
                                validator: (val) {
                                  val ??= "";
                                  val.length >= 10 ? null : errorInForm(0);
                                  return val.length >= 10
                                      ? null
                                      : "Enter a valid phone number";
                                },
                                decoration: Constants.kTextFormFieldDecoration(
                                    "PHONE NUMBER"),
                              ),
                              // SizedBox(height: 1.h),
                              TextFormField(
                                controller: addressController,
                                validator: (val) {
                                  val ??= "";
                                  return val.length >= 2
                                      ? null
                                      : "Enter a valid Address";
                                },
                                decoration:
                                    Constants.kTextFormFieldDecoration("ADDRESS"),
                              ),

                              //  SizedBox(height: 5.h),
                            ],
                          ),
                        ),
                      ),
                      Step(
                        title: Text(
                          'Company Details',
                          style: TextStyle(
                              color: error[1] ? Colors.red : Colors.black),
                        ),
                        content: Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: companyNameController,
                                validator: (val) {
                                  val ??= " ";
                                  val.length >= 2 ? null : errorInForm(1);
                                  return val.length >= 2
                                      ? null
                                      : "Enter a valid company name";
                                },
                                decoration: Constants.kTextFormFieldDecoration(
                                    "COMPANY NAME"),
                              ),
                              // SizedBox(height: 1.h),
                              TextFormField(
                                //  autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: companyDescriptionController,
                                validator: (val) {
                                  val ??= "";
                                  return val.length >= 2
                                      ? null
                                      : "Enter a valid Company Description";
                                },
                                decoration: Constants.kTextFormFieldDecoration(
                                    "COMPANY DESCRIPTION"),
                              ),
                              // SizedBox(height: 1.h),
                              TextFormField(
                                controller: companyEmailController,
                                validator: (val) {
                                  val ??= "";
                                  RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                          .hasMatch(val)
                                      ? null
                                      : errorInForm(1);
                                  return RegExp(
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                          .hasMatch(val)
                                      ? null
                                      : "Invalid Company Email";
                                },
                                decoration: Constants.kTextFormFieldDecoration(
                                    "COMPANY EMAIL"),
                              ),
                              //  SizedBox(height: 1.h),
                              TextFormField(
                                controller: companyPhoneController,
                                validator: (val) {
                                  val ??= "";
                                  return val.length >= 6
                                      ? null
                                      : "Enter a valid Phone Number";
                                },
                                decoration: Constants.kTextFormFieldDecoration(
                                    "COMPANY PHONE NUMBER"),
                              )

                              //  SizedBox(height: 5.h),
                            ],
                          ),
                        ),
                      ),
                      Step(
                        title: Text(
                          "Final Activation",
                          style: TextStyle(
                              color: error[2] ? Colors.red : Colors.black),
                        ),
                        content: Column(
                          children: [
                            DropDownDemo(
                              onChangedRole: (String val) {
                                print("this function is called with value $val");
                                dropDownValue = val.toLowerCase();
                              },
                            ),
                            TextFormField(
                              controller: activationCodeController,
                              validator: (val) {
                                val ??= "";
                                val.length > 1 ? null : errorInForm(2);
                                return val.length > 1
                                    ? null
                                    : "Enter a valid Activation Code";
                              },
                              decoration: Constants.kTextFormFieldDecoration(
                                  "ACTIVATION CODE"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //  SizedBox(height: 5.h),
                  GestureDetector(
                    onTap: () {
                      validateAndSignUp();
                      print("proceeding to sign up ${error[0]}");
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
                            return SignInPage(role: "admin",);
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
