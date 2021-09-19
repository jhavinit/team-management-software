import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:team_management_software/constants.dart';

import '../../change_notifier.dart';

class CreateTask extends StatefulWidget {
  String projectId;
   CreateTask({Key? key,required this.projectId}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {


  final taskNameController=TextEditingController();
  final taskDescriptionController=TextEditingController();
  int selectedPriority=0;
  int selectedStatus=0;

  Future<void>_dialogForAssign(){
    return showDialog<void>(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                  return Text("index");
                }),
              ],
            ),
          ),
        );
      }

    );
  }



  Future<void> _dialogForPriorityAndStatus(title) async {
    bool isPriority=false;
    if(title=="Priority"){
      isPriority=true;
    }
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
                Text(title),
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
                          isPriority?   selectedPriority=0:selectedStatus=0;
                          Navigator.pop(context);
                        },
                        child:  Constants.kWidgetForStatusAndPriority("----", Colors.grey[400]),
                      ),
                      GestureDetector(
                        onTap: (){
                          isPriority?   selectedPriority=1:selectedStatus=1;
                          Navigator.pop(context);
                        },
                        child:  Constants.kWidgetForStatusAndPriority(isPriority?"High":"Stuck", Colors.red),
                      ),
                      GestureDetector(
                        onTap: (){
                          isPriority?   selectedPriority=2:selectedStatus=2;
                          Navigator.pop(context);
                        },
                        child:  Constants.kWidgetForStatusAndPriority(isPriority?"Medium":"Working on it", Colors.purple[300]),
                      ),
                      GestureDetector(
                        onTap: (){
                          isPriority?   selectedPriority=3:selectedStatus=3;
                          Navigator.pop(context);
                        },
                        child:  Constants.kWidgetForStatusAndPriority(isPriority?"Low":"Done", Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }


  showSnackBArForProjectError(errorMessage) {
    final snackBar = SnackBar(
      content:  Text(errorMessage),
      duration: const Duration(milliseconds: 1000),
      // width: 200,
      margin: EdgeInsets.only(
          left: 40, right: MediaQuery.of(context).size.width - 250, bottom: 5),
      //  backgroundColor: Colors.yellow[800],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  createNewTask()async{
    //print("ccreate called");
    if(taskNameController.text!="" ) {
      if(isPicked){
        await context.read<Data>().addTaskInNotifier(

            taskName: taskNameController.text,
          taskDescription: taskDescriptionController.text,
          dueDate: selectedDate.toString(),
          projectId: widget.projectId,
          assignedTo: "emulator",
          priority: selectedPriority,
          status: selectedStatus,
        );
        Navigator.pop(context);
      }
      else {
        showSnackBArForProjectError("Select Date To Continue");
      }
    }
    else{
      showSnackBArForProjectError("Enter Required Fields");
    }
  }



  DateTime selectedDate=  DateTime.now();
  bool isPicked=false;
  String date=" ";

  selectDate(BuildContext context) async {
    final DateTime ?picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        isPicked=true;
        selectedDate = picked;
        date = picked.day.toString() +
            "-" +
            picked.month.toString() +
            "-" +
            picked.year.toString();

      });
    }
  }

  assignTask(){

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.18,
      color: Colors.red,
      alignment: Alignment.bottomCenter,
      child: Scaffold(
        body: Container(
          color: const Color(
              0xFF737373), // this color is similar to the color of non focused area
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0))),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 0, left: 50, right: 50),
                    child: Column(
                      children: [
                        const Text(
                          "_____",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 12, bottom: 20),
                          child: Column(
                            children: [
                              Text(
                                "Add New Task",
                                style: TextStyle(
                                    wordSpacing: 3,
                                    fontSize: 23,
                                    color: Colors.yellow[800],
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        //SizedBox(height: 20),
                        TextFormField(
                          autofocus: true,
                           controller: taskNameController,
                          onChanged: (val) {
                            // input=val;
                          },
                          decoration:
                          Constants.kTextFormFieldDecorationForFProject(
                              "TASK NAME *"),
                        ),
                        TextFormField(
                          controller: taskDescriptionController,
                          decoration:
                          Constants.kTextFormFieldDecorationForFProject(
                              "DESCRIPTION "),
                        ),

                        Container(
                          padding: EdgeInsets.only(top: 40),
                          child: Row(children: [
                          GestureDetector(
                            onTap:(){
                             // _dialogForAssign();
                              showSnackBArForProjectError("not implemented yet");

                        },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                  ),
                                  backgroundColor: Colors.grey[200],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Unassigned",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                            const SizedBox(
                              width: 30,
                            ),
                            true
                                ? GestureDetector(
                              onTap: (){
                                selectDate(context);
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        child:  Icon(
                                          Icons.date_range,
                                          color: isPicked?Colors.black:Colors.grey,
                                        ),
                                        backgroundColor: isPicked?Colors.yellow[800]: Colors.grey[200],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text( !isPicked?
                                      "Due Date":date,
                                        style: isPicked?const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600
                                        ):const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  )),
                            )
                                : Container(),

                          ]),
                        ),
                        SizedBox(height: 30,),
                        GestureDetector(
                          onTap: (){
                            _dialogForPriorityAndStatus("Priority");
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15)),
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(

                                    child: Text(
                                      "Priority",
                                      style: TextStyle(
                                          color: Colors.grey[900], fontSize: 18),
                                    ),
                                  ),
                                  selectedPriority==0?Constants.kWidgetForStatusAndPriority("---", Colors.grey[400]):Container(),
                                  selectedPriority==1?Constants.kWidgetForStatusAndPriority("HIGH", Colors.red):Container(),
                                  selectedPriority==2?Constants.kWidgetForStatusAndPriority("MEDIUM", Colors.purple[300]):Container(),
                                  selectedPriority==3?Constants.kWidgetForStatusAndPriority("LOW", Colors.green):Container(),
                                ],
                              )),
                        ),
                        SizedBox(height: 20,),
                        GestureDetector(
                          onTap: (){
                            _dialogForPriorityAndStatus("Status");
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15)),
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(

                                    child: Text(
                                      "Status",
                                      style: TextStyle(
                                          color: Colors.grey[900], fontSize: 18),
                                    ),
                                  ),
                                  selectedStatus==0?Constants.kWidgetForStatusAndPriority("---", Colors.grey[400]):Container(),
                                  selectedStatus==1?Constants.kWidgetForStatusAndPriority("STUCK", Colors.red):Container(),
                                  selectedStatus==2?Constants.kWidgetForStatusAndPriority("WORKING ON IT", Colors.purple[300]):Container(),
                                  selectedStatus==3?Constants.kWidgetForStatusAndPriority("DONE", Colors.green[400]):Container(),


                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          bottom: 100,
                          right: 40,
                        ),
                        child: RawMaterialButton(
                          onPressed: () {
                            createNewTask();

                          },
                          fillColor: Colors.yellow[800],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: const Text(
                            "Add",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
