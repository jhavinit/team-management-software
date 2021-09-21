import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:team_management_software/controller/shared_prefernce_functions.dart';
import 'package:team_management_software/views/screens/profileinfo.dart';
import 'package:team_management_software/views/welcome_screen.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.account_circle,
                      size: 100,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    height: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        "Username",
                        style: TextStyle(fontSize: 26, color: Colors.black),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text("Email Id"),
                      SizedBox(
                        height: 3,
                      ),
                      GestureDetector(
                        child: new Text(
                          "View Profile",
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
              padding: const EdgeInsets.all(8.0),
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
                      subtitle: Text('KSVR'),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Notifications",
                ),
              ),
            ),
            Container(
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(
                        Icons.do_disturb_on_outlined,
                        size: 30,
                      ),
                      title: Text('Do not disturb'),
                      subtitle: Text('Off'),
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
                        Icons.crop_square,
                        size: 30,
                      ),
                      title: Text('Push'),
                      subtitle: Text('Manage'),
                    ),
                  ],
                ),
              ),
            ),
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
