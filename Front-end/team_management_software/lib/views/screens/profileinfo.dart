import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:team_management_software/constants.dart';
import 'package:team_management_software/controller/shared_prefernce_functions.dart';

import '../../change_notifier.dart';

class ViewProfile extends StatefulWidget {

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  String username="",designation="",email="",projectNumber="",taskNumber="";
  bool isLoaded=false;
  var projectList=[];
  var taskList=[];

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }
  @override
  void didChangeDependencies() async {
    await getTaskList();
    super.didChangeDependencies();
  }

  getTaskList() {
    taskList = context.watch<Data>().listOfMyTasksNotifier;
  }

  getUserDetails() async{
      var userDetails=await  SharedPreferencesFunctions.getUserDetails();
      var finalData=jsonDecode(userDetails);
      username=finalData["username"]??"";
      email=finalData["email"]??"";
      designation=finalData["designation"]??"";
      projectList=finalData["projects"];
      try{

        projectNumber=finalData["projects"].length.toString();
      }catch(e){
        projectNumber="0";
      }

      print("okay");
      print("projectNumber is $projectNumber");
      setState(() {
        isLoaded=true;
      });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.yellow[800],
          ),
        ),
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

          // IconButton(
          //   icon: Icon(
          //     Icons.edit,
          //     color: Colors.yellow[800],size: 30,
          //   ),
          //   onPressed: () {
          //     // do something
          //   },
          // ),
          // IconButton(
          //   icon: Icon(
          //     Icons.settings,
          //     color: Colors.yellow[800],
          //   ),
          //   onPressed: () {
          //     // do something
          //   },
          // )
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
                         Text(
                          username,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          email,
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          designation,
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
                                  children:  [
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
                                     projectNumber,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children:  [
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
                                      taskList.length.toString(),
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

                  Container(
                      padding: EdgeInsets.only(top: 20),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Projects",
                        style: TextStyle(color: Colors.grey,fontSize: 22,fontWeight: FontWeight.w400),
                      )),
                  projectList.isEmpty?
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.topLeft,
                       child: Text("No active Projects...",style:TextStyle(color: Colors.grey,fontSize:14))
                      ):
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                      //30,
                      projectList.length,
                      itemBuilder: (context, index) {
                        var data = projectList[index];
                        return
                            Container(
                              margin:
                              const EdgeInsets.only(top:4,bottom: 4),
                              decoration: BoxDecoration(

                                borderRadius:
                                BorderRadius.all(
                                    Radius.circular(
                                        10)),
                                color: Colors.grey[200],
                              ),
                              padding:
                              EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8),
                              child: Container(
                                child: Text(data["projectName"]??"",
                                  style: TextStyle(),
                                ),
                              ),
                            );
                          //  Expanded(child: Container())
                         // ],
                        //);
                      }),
                  Container(
                      padding: EdgeInsets.only(top: 20),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Tasks",
                        style: TextStyle(color: Colors.grey,fontSize: 22,fontWeight: FontWeight.w400),
                      )),

                  taskList.isEmpty?
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      alignment: Alignment.topLeft,
                      child: Text("No active tasks...",style:TextStyle(color: Colors.grey,fontSize:14))
                  ):
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                      //30,
                      taskList.length,
                      itemBuilder: (context, index) {
                        var data = taskList[index];
                        return
                          Container(
                            margin:
                            const EdgeInsets.only(top:4,bottom: 4),
                            decoration: BoxDecoration(

                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(
                                      10)),
                              color: Colors.grey[200],
                            ),
                            padding:
                            EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8),
                            child: Container(
                              child: Text(data["taskname"]??"",
                                style: TextStyle(),
                              ),
                            ),
                          );
                        //  Expanded(child: Container())
                        // ],
                        //);
                      }),


            //
            //       TextFormField(
            //
            //         decoration: Constants.kTextFormFieldDecoration("Add Bio"),
            //         maxLines: 2,
            //       ),
            //       TextFormField(
            //         decoration: Constants.kTextFormFieldDecoration("Skills"),
            //         maxLines: 2,
            //       ),
            //       TextFormField(
            //         decoration: Constants.kTextFormFieldDecoration("Experience"),
            //         maxLines: 2,
            //       ),
            //       TextFormField(
            //         decoration: Constants.kTextFormFieldDecoration("Address"),
            //         maxLines: 2,
            //       ),
            //       TextFormField(
            //         decoration: Constants.kTextFormFieldDecoration("Contact"),
            //         maxLines: 2,
            //       ),
            //       TextFormField(
            //         decoration: Constants.kTextFormFieldDecoration("Education"),
            //         maxLines: 2,
            //       ),
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
