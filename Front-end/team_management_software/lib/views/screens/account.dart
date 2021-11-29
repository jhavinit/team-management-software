import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:team_management_software/constants.dart';
import 'package:team_management_software/controller/shared_prefernce_functions.dart';
import 'package:team_management_software/views/screens/profileinfo.dart';
import 'package:team_management_software/views/welcome_screen.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  String userName="",email="";
  bool isLoaded=false;

  @override
  void initState() {
    // TODO: implement initState
    print("the role is ${Constants.role}");
    getFromSharedPref();
    super.initState();
  }

  getFromSharedPref() async{
   var userDetails=await  SharedPreferencesFunctions.getUserDetails();
  var finalData=jsonDecode(userDetails);
  userName=finalData["username"];
  email=finalData["email"];
  setState(() {
    isLoaded=true;
  });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        automaticallyImplyLeading: false,
        title: Text(
          "Account",
          style: TextStyle(
              color: Colors.yellow[800],
              fontWeight: FontWeight.w300,
              fontSize: 25),
        ),
        backgroundColor: Colors.black,
      ),
      body:  SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child:
                    Container(
                      height: 140.0,
                      width: 140.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                          image: DecorationImage(
                              image: new AssetImage("images/avatarTMS.png"),
                              fit: BoxFit.cover)),
                    ),

                  ),
                  SizedBox(
                    width: 25,
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                       userName,
                        style: TextStyle(fontSize: 26, color: Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(email,style: TextStyle(color: Colors.grey),),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        child: new Text(
                          " View Profile",
                          style: TextStyle(color: Colors.yellow[800]),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewProfile()));
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(top: 20,bottom: 10,left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Organisation",
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(
                        Icons.work,
                        size: 30,
                      ),
                      title: Text('My Company'),
                      subtitle: Text('DIC'),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Align(
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       "Notifications",
            //     ),
            //   ),
            // ),
            // Container(
            //   child: Card(
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: const <Widget>[
            //         ListTile(
            //           leading: Icon(
            //             Icons.do_disturb_on_outlined,
            //             size: 30,
            //           ),
            //           title: Text('Do not disturb'),
            //           subtitle: Text('Off'),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   padding: const EdgeInsets.only(bottom: 8),
            //   child: Card(
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: <Widget>[
            //         const ListTile(
            //           leading: Icon(
            //             Icons.crop_square,
            //             size: 30,
            //           ),
            //           title: Text('Push'),
            //           subtitle: Text('Manage'),
            //         ),
            //       ],q
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Support",
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        size: 30,
                      ),
                      title: Text('Android Guide'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(
                        Icons.help_outline,
                        size: 30,
                      ),
                      title: Text('Contact Support'),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                SharedPreferencesFunctions.setIsUserLoggedIn(false);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                  return WelcomeScreen();
                }));
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: Center(
                    child: const ListTile(
                      title: Text(
                        'Log Out',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
