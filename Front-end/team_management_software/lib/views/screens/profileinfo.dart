import 'package:flutter/material.dart';
import 'package:team_management_software/constants.dart';

class ViewProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        title: Text(
          "Profile Info",
          style: TextStyle(
              color: Colors.yellow[800],
              fontWeight: FontWeight.w300,
              fontSize: 25),
        ),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.yellow[800],size: 30,
            ),
            onPressed: () {
              // do something
            },
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.yellow[800],
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            // background image and bottom contents
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/background.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(120, 50, 0, 0),
                    child: Column(
                      children: [
                        const Text(
                          "DIC member",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Designation",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Company",
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Column(
                                  children: const [
                                    Text(
                                      "Project",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "3",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: const [
                                    Text(
                                      "Tasks",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "10",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 210, 0, 0),
              child: Column(
                children: [
                  TextFormField(

                    decoration: Constants.kTextFormFieldDecoration("Add Bio"),
                    maxLines: 2,
                  ),
                  TextFormField(
                    decoration: Constants.kTextFormFieldDecoration("Skills"),
                    maxLines: 2,
                  ),
                  TextFormField(
                    decoration: Constants.kTextFormFieldDecoration("Experience"),
                    maxLines: 2,
                  ),
                  TextFormField(
                    decoration: Constants.kTextFormFieldDecoration("Address"),
                    maxLines: 2,
                  ),
                  TextFormField(
                    decoration: Constants.kTextFormFieldDecoration("Contact"),
                    maxLines: 2,
                  ),
                  TextFormField(
                    decoration: Constants.kTextFormFieldDecoration("Education"),
                    maxLines: 2,
                  ),
                ],
              ),
            ),

            // Profile image
            Positioned(
              top: 30.0,
              left: 23, // (background container size) - (circle height / 2)
              child: Container(
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
          ],
        ),
      ),
    );
  }
}
