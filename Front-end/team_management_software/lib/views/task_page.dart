// ignore_for_file: must_be_immutable, implementation_imports

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/src/provider.dart';
import 'package:team_management_software/constants.dart';
import '../change_notifier.dart';

class TaskPage extends StatefulWidget {
  bool isCompleted;
  String taskName;
  String taskDescription;
  String dueDate;
  int priority;//0 1 2 3
  int status;//0 1 2 3
  String assignedBy;
  String assignedTo;
  String imageUrl;
  String projectOfTask;
  String projectId;
  bool isAssigned;
  String taskId;
  int index;
  bool isMyTask;
  String projectName;
   TaskPage({Key? key,
     required this.assignedBy,required this.assignedTo,required this.status,required this.priority,required this.projectOfTask,
     required this.imageUrl,required this.isCompleted,required this.taskId,required this.index,required this.projectId,
     required this.taskName,required this.taskDescription,required this.dueDate, required this.isAssigned,required this.projectName,
   required this.isMyTask}) : super(key: key);
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  bool editable=false;
  final taskNameController = TextEditingController();
  final taskDescriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool isPicked = true;
  String date = " ";
  List usersListForAssign=[
  ];
  int selectedPriority=0;
  int selectedStatus=0;
  String assignedTo="";
  bool isAssigned=false;
  bool isCompleted=false;



  @override
  void didChangeDependencies() {
    usersListForAssign=context.watch<Data>().listOfTokensNotifier;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }


  @override
  initState(){

    isCompleted=widget.isCompleted;
    editable=false;
    taskDescriptionController.text = widget.taskDescription;
    taskNameController.text = widget.taskName;
    selectedPriority=widget.priority;
    selectedStatus=widget.status;
    assignedTo=widget.assignedTo;
    isAssigned=widget.isAssigned;
    selectedPriority=widget.priority;
    print("priority $selectedPriority");
    resolveDate();
    super.initState();
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

                          setState(() {
                            isPriority?   selectedPriority=0:selectedStatus=0;
                          });
                          Navigator.pop(context);
                        },
                        child:  Constants.kWidgetForStatusAndPriority("----", Colors.grey[400]),
                      ),
                      GestureDetector(
                        onTap: (){

                          setState(() {
                            isPriority?   selectedPriority=1:selectedStatus=1;
                          });
                          Navigator.pop(context);

                        },
                        child:  Constants.kWidgetForStatusAndPriority(isPriority?"High":"Stuck", Colors.red),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            isPriority?   selectedPriority=2:selectedStatus=2;
                          });
                          Navigator.pop(context);
                        },
                        child:  Constants.kWidgetForStatusAndPriority(isPriority?"Medium":"Working on it", Colors.purple[300]),
                      ),
                      GestureDetector(
                        onTap: (){

                          setState(() {
                            isPriority?   selectedPriority=3:selectedStatus=3;
                          });

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


  resolveDate(){
    try{
      var temp = DateTime.parse(widget.dueDate);
      selectedDate=temp;
      date = "${temp.day}-${temp.month}-${temp.year}";
    }catch(e){
      selectedDate=DateTime.now();
      print(e);
    }
  }
  Widget setupAlertDialogContainer(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          //color: Colors.grey,
          height: 300.0, // Change as per your requirement
          width: 200.0, // Change as per your requirement
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: usersListForAssign.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: (){
                  isAssigned=true;
                  assignedTo=usersListForAssign[index]["fullName"]!;
                  setState(() {
                  });
                  Navigator.pop(context);

                },
                dense: true,
                //tileColor: Colors.red,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                title: Text(usersListForAssign[index]["fullName"]??"noName",
                ),
                subtitle: Text(usersListForAssign[index]["email"]??"noEmail"),
                leading:  const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper.png"),
                ),
              );
            },
          ),
        ),

      ],
    );
  }

  Future<void>_dialogForAssign(){
    return showDialog<void>(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            content: setupAlertDialogContainer(context)

          );
        }

    );
  }
  markingTaskAsComplete(){
    print("markingTask...${isCompleted}");
    context.read<Data>().marksTaskAsComplete(index: widget.index,
        projectId: widget.projectId, taskId: widget.taskId, isCompleted: isCompleted,isMyTask: widget.isMyTask);
  }

  sendUpdatedTaskData(){

    var dataToUpdate={
      "taskname":taskNameController.text,
      "taskDescription":taskDescriptionController.text,
      "dueDate":selectedDate.toString(),
      "assignedTo":assignedTo,
      "priority":selectedPriority,
      "status":selectedStatus,
      "isAssigned":isAssigned
    };
    print(dataToUpdate);

    context.read<Data>().updateIndividualTask(
      index: widget.index,
      projectId: widget.projectId,
        taskId: widget.taskId,
      priority: selectedPriority,
      status: selectedStatus,
      taskDescription:taskDescriptionController.text ,
      taskName: taskNameController.text,
      dueDate: selectedDate.toString(),
      assignedTo: assignedTo,
      dataToSend: dataToUpdate,
      isMyTask: widget.isMyTask
    );
  }

  selectDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2022),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        isPicked = true;
        selectedDate = picked;
        date = picked.day.toString() +
            "-" +
            picked.month.toString() +
            "-" +
            picked.year.toString();
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton
            (
            onPressed: (){
              Navigator.pop(context);

            },
            icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
          ),
          actions: [
            Constants.role=="admin"?     IconButton(
              tooltip: "Mark as done",
              padding: EdgeInsets.symmetric(horizontal: 10),
              onPressed: () {
                setState(() {
                  //widget.isCompleted=!widget.isCompleted;
                  isCompleted=!isCompleted;
                  markingTaskAsComplete();
                  setState(() {
                    editable=false;
                   // editable?editable=!editable:null;
                  });
                });
              },
              icon:  Icon(
                Icons.done,
                color: isCompleted?Colors.teal:Colors.black,
                size: 30,
              ),
            ):Container(),
            Constants.role=="admin"?     IconButton(
              tooltip: "Save",
              padding: EdgeInsets.symmetric(horizontal: 10),
              onPressed: () {
                editable?sendUpdatedTaskData():null;
                setState(() {
                  editable=false;
               // editable?editable=!editable:null;
                });

              },
              icon: Icon(Icons.save, color: editable?Colors.teal:Colors.grey[300]),
            ):Container(),
            Constants.role=="admin"?     IconButton(
              padding: EdgeInsets.symmetric(horizontal: 10),
              onPressed: () {
                setState(() {
                  editable=!editable;
                  print("editable  $editable");
                });
              },
              icon:  Icon(
                editable? Icons.create:Icons.create_outlined,
                color: Colors.black,
              ),
            ):Container(),
            Constants.role=="admin"?     IconButton(
              padding: EdgeInsets.only(right: 15),
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ):Container(),
          ],
          elevation: 1,
          shadowColor: Colors.grey[400],
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
               isCompleted? Container(
                  color: Colors.teal[500],
                  padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12),
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:  [
                      const Icon(
                        Icons.task_alt_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      //todo rich text here
                      const Text(" Task Completed ", style: TextStyle(fontSize: 13,fontWeight:FontWeight.bold,color: Colors.white)),
                      Text(
                        " by ${widget.assignedTo}",
                        style: const TextStyle(
                          // fontFamily: 'Open Sans',
                            color: Colors.white,
                            fontSize: 12),
                      )
                    ],
                  ),
                ):Container(),
                Container(
                  color: Colors.grey[300],
                  padding: EdgeInsets.only(left: 20, top: 6, bottom: 6),
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:  [
                      const Icon(
                        Icons.task,
                        size: 18,
                      ),
                      //todo rich text here
                      const Text(" Assigned by  ", style: TextStyle(fontSize: 12)),
                      Text(
                       widget.assignedBy,
                        style: const TextStyle(
                            // fontFamily: 'Open Sans',
                            color: Colors.purple,
                            fontSize: 15),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(

                        //maxLines: 2,
                        style: const TextStyle(fontSize: 30),
                         readOnly: !editable,
                        autofocus: false,
                        controller: taskNameController,
                        onChanged: (val) {
                        },
                        decoration: Constants.kTextFormFieldDecorationForTask(
                            "TASK NAME"),
                      ),
                      TextFormField(
                        readOnly: !editable,
                        autofocus: false,
                        maxLines: 2,
                       // readOnly: true,
                        style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                        //readOnly: true,
                        controller: taskDescriptionController,
                        decoration: Constants.kTextFormFieldDecorationForTask(
                            "DESCRIPTION "),
                      ),
                      Container(
                       // padding: EdgeInsets.only(top: 20),
                        child: Row(children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                               // widget.isAssigned = ! widget.isAssigned ;
                               editable? _dialogForAssign():null;
                              });
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child:
                                 // ! widget.isAssigned?
                                   Icon(
                                          Icons.person,
                                          color: ! widget.isAssigned
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                              //        :
                              //     const Text(
                              //             "Ro",
                              //             style: TextStyle(
                              //                 fontWeight: FontWeight.bold,
                              //                 color: Colors.black),
                              //           ),
                                  backgroundColor: ! widget.isAssigned
                                      ? Colors.grey[200]
                                      : Colors.yellow[800],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 100,
                                  child: Text(
                                    isAssigned  ? assignedTo: "Unassigned",
                                    style:  widget.isAssigned
                                        ? const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18)
                                        : TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              editable?selectDate(context):null;
                            },
                            child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      child: Icon(
                                        Icons.date_range,
                                        color: isPicked
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                      backgroundColor: isPicked
                                          ? Colors.yellow[800]
                                          : Colors.grey[200],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      !isPicked ? "Due Date" : date,
                                      style: isPicked
                                          ? const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)
                                          : const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                )),
                          )
                        ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: (){
                         editable? _dialogForPriorityAndStatus("Priority"):null;
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 6),
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
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: (){
                      editable?   _dialogForPriorityAndStatus("Status"):null;
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 6),
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 20),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Project",
                            style: TextStyle(color: Colors.grey[600]),
                          )),
                      Container(

                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                        color: Colors.grey[200],
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              margin: EdgeInsets.symmetric(vertical: 8,),
                              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                              child:  Text(
                                widget.projectName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,

                                ),
                              ),
                            ),
                            Expanded(
                              child:Container()
                            )
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Attachments",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    Container(

                      alignment: Alignment.topLeft,
                        child: Image.asset("images/LOGO2.png",height: 100,))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
