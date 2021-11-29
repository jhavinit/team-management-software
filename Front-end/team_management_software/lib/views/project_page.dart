import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/src/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../change_notifier.dart';
import '../constants.dart';

// ignore: must_be_immutable
class ProjectPage extends StatefulWidget {
  String projectId;
  String projectName;
  String projectDescription;
  int index;
  bool isArchived;
  bool isFav;

  ProjectPage(
      {Key? key,
      required this.projectName,
      required this.projectDescription,
      required this.index,
      required this.projectId,
      required this.isArchived,required this.isFav}
  ) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  var usersListForAssign;
  var listForMembers = [];
  var listForTasks = [];
  final projectNameController = TextEditingController();
  final projectDescriptionController = TextEditingController();
  bool editable = false;
  bool isArchived = false;
  String newMember="";
  bool isFav=false;

  updateTaskListAndMembersList() async {
    Future.delayed(Duration.zero, () async {
      await context
          .read<Data>()
          .getTaskListAndMemberListForProject(widget.index);
    });
  }

  @override
  void initState() {
    projectNameController.text = widget.projectName;
    projectDescriptionController.text = widget.projectDescription;
    isArchived = widget.isArchived;
    isFav=widget.isFav;
    updateTaskListAndMembersList();

    super.initState();
  }

  bool isLoading = false;
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    usersListForAssign=context.watch<Data>().listOfTokensNotifier;
    listForMembers =
        context.watch<Data>().taskMembersOfParticularProjectNotifier;
    listForTasks = context.watch<Data>().taskListOfParticularProjectNotifier;

    super.didChangeDependencies();
  }
  addMemberToList(){
    context.read<Data>().addMemberToList(newMember,widget.projectId);
  }

  sendUpdatedProjectData() {
    var dataToUpdate = {
      "name": projectNameController.text,
      "description": projectDescriptionController.text,
      "isArchived": isArchived,
      "isFav":isFav
      //"isActive":false,
    };

    context.read<Data>().updateIndividualProject(
          index: widget.index,
          projectId: widget.projectId,
          dataToSend: dataToUpdate,
          isArchived: isArchived,
          projectDescription: projectDescriptionController.text,
          isDeleted: false,
          projectName: projectNameController.text,
      isFav: isFav
        );
  }


  Widget setupAlertDialogContainer(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 20),
          child: Text("Add Member to Project"),),
        Container(
          //color: Colors.grey,
          height: 300.0, // Change as per your requirement
          width: 200.0, // Change as per your requirement
          child: ListView.builder(
            shrinkWrap: true,
            itemCount:usersListForAssign.length,
            //usersListForAssign.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: (){
                  newMember=usersListForAssign[index]["fullName"];
                  addMemberToList();

                  // setState(() {
                  // });
                  Navigator.pop(context);

                },
                dense: true,
                //tileColor: Colors.red,
                horizontalTitleGap: 10,
                contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal:0),
                title: Text(usersListForAssign[index]["fullName"]??"noName",
                ),
                subtitle: Text(usersListForAssign[index]["email"]??"noEmail"),
                leading:  const CircleAvatar(
                  backgroundImage:
                  AssetImage('images/avatarTMS.png'),
                  // NetworkImage(
                  //     "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper.png"),
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




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading:
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          actions: [
       Constants.role=="admin"?     IconButton(
              tooltip: "Save",
              padding: EdgeInsets.symmetric(horizontal: 10),
              onPressed: () {
                editable ? sendUpdatedProjectData() : null;
                setState(() {
                  editable = false;
                  // editable?editable=!editable:null;
                });
              },
              icon: Icon(Icons.save,
                  color: editable ? Colors.teal : Colors.grey[300]),
            ):Container(),
            Constants.role=="admin"?      IconButton(
              padding: EdgeInsets.symmetric(horizontal: 10),
              onPressed: () {
                setState(() {
                  editable = !editable;
                  print("editable  $editable");
                });
              },
              icon: Icon(
                editable ? Icons.create : Icons.create_outlined,
                color: Colors.black,
              ),
            ):Container(),
            Constants.role=="admin"?      PopupMenuButton<String>(
              padding: EdgeInsets.only(right: 10),
              // color: Colors.grey[100],
              offset: const Offset(50, 56),
              onSelected: (String value) {
                if (value == "archive") {
                  print(".............");
                  setState(() {
                    editable = true;
                    isArchived = !isArchived;
                  });
                }else if(value=="Fav"){
                  print("adding to the fav");
                  setState(() {
                    isFav=!isFav;
                    editable=true;
                  });
                }
              },
              icon: const Icon(
                Icons.more_vert,
                size: 30,
                color: Colors.black,
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  //padding: EdgeInsets.only(left: 20),
                  value: "archive",
                  child: Row(
                    children: [
                      Icon(
                        isArchived ? Icons.unarchive : Icons.archive,
                        color: isArchived ? Colors.blue : Colors.blueGrey,
                        size: 30,
                      ),
                      Text(isArchived ? ' Unarchive' : ' Archive Project'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  //padding: EdgeInsets.only(left: 20),
                  value: "Fav",
                  child: Row(
                    children: [
                      Icon(
                        isFav ? Icons.favorite : Icons.favorite_border_outlined,
                        color: isFav ? Colors.red : Colors.blueGrey,
                        size: 30,
                      ),
                      Text(isFav ? ' Remove Favourite' : ' Add Favourite'),
                    ],
                  ),
                ),

                PopupMenuItem<String>(
                  value: 'Delete',
                  child: Row(
                    children: const [
                      Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.red,
                        size: 30,
                      ),
                      Text(' Delete'),
                    ],
                  ),
                ),
              ],
            ):Container(),
          ],
          elevation: 1,
          shadowColor: Colors.grey[400],
          backgroundColor: Colors.white,
        ),
        body: isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          color: Colors.teal[500],
                          padding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.create_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                              //todo rich text here
                              Text(" Project Created  ",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Text(
                                " by Admin",
                                style: TextStyle(
                                    // fontFamily: 'Open Sans',
                                    color: Colors.white,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.grey[300],
                          padding: EdgeInsets.only(left: 20, top: 6, bottom: 6),
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isArchived ? Icons.lock : Icons.lock_open_sharp,
                                size: 18,
                              ),
                              //todo rich text here
                              Text(
                                  isArchived
                                      ? " Project is Archived  "
                                      : "  Project is Visible",
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 30, right: 30),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextFormField(
                                  maxLines: 2,
                                  style: TextStyle(fontSize: 30),
                                  // readOnly: true,
                                  readOnly: !editable,
                                  autofocus: false,
                                  controller: projectNameController,
                                  onChanged: (val) {},
                                  decoration:
                                      Constants.kTextFormFieldDecorationForTask(
                                          "PROJECT NAME"),
                                ),
                                TextFormField(
                                  maxLines: 2,
                                  readOnly: !editable,
                                  autofocus: false,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.grey[700]),
                                  //readOnly: true,
                                  controller: projectDescriptionController,
                                  decoration:
                                      Constants.kTextFormFieldDecorationForTask(
                                          "DESCRIPTION "),
                                ),
                                Container(
                                    padding: EdgeInsets.only(
                                        top: 20, bottom: 10),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "LINKS",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15),
                                    )
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  
                                  child:InkWell(
                                      child:  Text('Github link'),
                                      onTap: ()
                                     async {
                                       await canLaunch(
                                            'https://http://flutter.dev')
                                            ?
                                        launch(
                                            'http://flutter.dev')
                                            : print("cannot launch");
                                      }
                                  ),
                                ),

                                Container(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 10),
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          "TEAM MEMBERS",
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14),
                                        ),
                                        const SizedBox(width: 10,),
                                        Constants.role=="admin"?      GestureDetector(
                                          onTap: (){
                                            _dialogForAssign();
                                          },
                                          child: const CircleAvatar(
                                            maxRadius: 12,

                                            foregroundColor: Colors.white,
                                              backgroundColor: Colors.blueGrey,
                                              child: Icon(Icons.add)),
                                        ):Container()
                                      ],
                                    )),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    listForMembers.isEmpty
                                        ? Container(
                                            alignment: Alignment.topLeft,
                                            padding:
                                                EdgeInsets.only(bottom: 20),
                                            child: const Text(
                                              "No members were added to project...",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13),
                                            ),
                                          )
                                        : ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: listForMembers.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      color: Colors.grey[300],
                                                    ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 8),
                                                    child: Text(
                                                      listForMembers[index]
                                                          ["memberName"],
                                                      style: TextStyle(),
                                                    ),
                                                  ),
                                                  Expanded(child: Container())
                                                ],
                                              );
                                            },
                                          ),
                                    Container(
                                        padding: EdgeInsets.only(
                                            top: 20, bottom: 10),
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "TASKS IN THE PROJECT",
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 15),
                                        )),
                                    listForTasks.isEmpty
                                        ? Container(
                                            alignment: Alignment.topLeft,
                                            padding:
                                                const EdgeInsets.only(bottom: 20),
                                            child: const Text(
                                              "No Active Tasks in the project...",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13),
                                            ),
                                          )
                                        : ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: listForTasks.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      color: Colors.grey[300],
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 8),
                                                    child: Text(
                                                      listForTasks[index]
                                                          ["taskName"],
                                                      style: TextStyle(),
                                                    ),
                                                  ),
                                                  Expanded(child: Container())
                                                ],
                                              );
                                            },
                                          ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 50),
                                    )
                                  ],
                                )
                              ]),
                        ),
                      ]),
                ),
              ),
      ),
    );
  }
}
