import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/src/provider.dart';

import '../change_notifier.dart';
import '../constants.dart';

class ProjectPage extends StatefulWidget {
  String projectId;
  String projectName;
  String projectDescription;
  int index;

   ProjectPage({Key? key,required this.projectName,required this.projectDescription,required this.index,
   required this.projectId}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  var listForMembers;
  var listForTasks;
  final projectNameController = TextEditingController();
  final projectDescriptionController = TextEditingController();
  bool editable=false;

  updateTaskListAndMembersList()async{
    await context.read<Data>().getTaskListAndMemberListForProject(widget.index);
  }

  @override
  void initState() {
    projectNameController.text = widget.projectName;
    projectDescriptionController.text = widget.projectDescription;
    updateTaskListAndMembersList();

    super.initState();
  }


  bool isLoading =true;
  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies

    listForMembers= context.watch<Data>().taskMembersOfParticularProjectNotifier;
    listForTasks=context.watch<Data>().taskListOfParticularProjectNotifier;
    setState(() {
      isLoading=false;
    });
    super.didChangeDependencies();
  }
  sendUpdatedProjectData(){

    var dataToUpdate={
      "name":projectNameController.text,
      "description":projectDescriptionController.text,
      "isArchived":false,
      "isActive":false,
    };

    context.read<Data>().updateIndividualProject(
        index: widget.index,
        projectId: widget.projectId,
        dataToSend: dataToUpdate,
        isArchived: false,
      projectDescription: projectDescriptionController.text,
      isDeleted: false,
      projectName: projectNameController.text,

    );


  }

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              tooltip: "Save",
              padding: EdgeInsets.symmetric(horizontal: 10),
              onPressed: () {
                editable?sendUpdatedProjectData():null;
                setState(() {
                  editable=false;
                  // editable?editable=!editable:null;
                });
              },
              icon: Icon(Icons.save, color: editable?Colors.teal:Colors.grey[300]),
            ),
            IconButton(
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
            ),
            IconButton(
              padding: EdgeInsets.only(right: 15),
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
          ],
          elevation: 1,
          shadowColor: Colors.grey[400],
          backgroundColor: Colors.white,
        ),
        body: isLoading?CircularProgressIndicator():SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Colors.teal[500],
                    padding: EdgeInsets.only(left: 20, top: 6, bottom: 6),
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
                      children: const [
                        Icon(
                          Icons.lock,
                          size: 18,
                        ),
                        //todo rich text here
                        Text(" Project is Archived  ",
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 30, right: 30),
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
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[700]),
                            //readOnly: true,
                            controller: projectDescriptionController,
                            decoration:
                                Constants.kTextFormFieldDecorationForTask(
                                    "DESCRIPTION "),
                          ),
                          Container(
                              padding: const EdgeInsets.only(top: 20, bottom: 12),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "TEAM MEMBERS",
                                style: TextStyle(color: Colors.grey[600],fontSize: 14),
                              )),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: listForMembers.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Container(
                                        margin:const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),

                                          color: Colors.grey[300],
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                                        child: Text(
                                          listForMembers[index]["memberName"],
                                          style: TextStyle(),
                                        ),
                                      ),
                                      Expanded(child:
                                      Container())
                                    ],
                                  );
                                },
                              ),
                              Container(
                                  padding: EdgeInsets.only(top: 20, bottom: 20),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "TASKS IN THE PROJECT",
                                    style: TextStyle(color: Colors.grey[600],fontSize: 15),
                                  )),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: listForTasks.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Container(
                                        margin:const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),

                                          color: Colors.grey[300],
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                                        child: Text(
                                          listForTasks[index]["taskName"],
                                          style: TextStyle(),
                                        ),
                                      ),
                                      Expanded(child:
                                      Container())
                                    ],
                                  );
                                },
                              ),
                              Container(padding: EdgeInsets.only(bottom: 50),)
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
