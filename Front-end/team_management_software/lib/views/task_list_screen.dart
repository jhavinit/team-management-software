// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:team_management_software/views/components/new_task.dart';
import 'package:provider/src/provider.dart';
import 'package:team_management_software/views/components/task_tile.dart';
import 'package:team_management_software/views/task_page.dart';

import '../../change_notifier.dart';

class TaskListScreen extends StatefulWidget {
  final String projectId, projectName;
  TaskListScreen({Key? key, required this.projectId, required this.projectName})
      : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  var taskList;
  bool isLoading = true;
  bool loadingScreen=false;

  getTaskList() {
    taskList = context.watch<Data>().taskListNotifier;
    loadingScreen=context.watch<Data>().loadingScreen;
  }

  updateTaskList() async {
    await context
        .read<Data>()
        .getTasksListFromServerForProject(widget.projectId);
    isLoading = false;
  }

  @override
  void initState() {
    // getDeviceToken();
    //updateConversationList();
    print(widget.projectId +".............................................");
    updateTaskList();

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    getTaskList();
    //await getTaskList("okay");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loadingScreen,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              showModalBottomSheet<void>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return CreateTask(
                    projectId: widget.projectId,
                  );
                },
              );
            },
            child: Icon(
              Icons.add_task,
              color: Colors.yellow[800],
              size: 35,
            )),
        appBar: AppBar(
          leadingWidth: 30,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                //color: Colors.red,
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: Colors.yellow[800],
                )),
          ),
          title: Text(
            widget.projectName,
            style: TextStyle(
                color: Colors.yellow[800],
                fontWeight: FontWeight.w300,
                fontSize: 25),
          ),
          backgroundColor: Colors.black,
        ),
        body: isLoading
            ? Center(
              child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("fetching tasks for...",style: TextStyle(color:Colors.grey[400],fontWeight: FontWeight.w400),),
                  Text("${widget.projectName}",style: TextStyle(color:Colors.yellow[800],fontWeight:FontWeight.w300,fontSize: 20),),
                  SizedBox(height:2),



                  SizedBox(height:10),
                  CircularProgressIndicator(
                    color: Colors.yellow[800],
                    backgroundColor: Colors.black,
                  ),
                ],
              ),
            )
            : taskList.isEmpty? Center(
          child: Text("No active task...",style: TextStyle(color: Colors.grey),),
        ):Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],

              ),
              padding: EdgeInsets.only(left: 30,top: 8,bottom: 10,right: 10),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: Text("Tasks",style: TextStyle(
                        fontSize: 18,fontWeight: FontWeight.bold,color: Colors.teal[800]
                      ),),),
                  Text("Due Date",style: TextStyle(
                  fontSize: 15,fontWeight: FontWeight.bold,color: Colors.blueGrey
                  ),)
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                //30,
                                taskList.length,
                            itemBuilder: (context, index) {
                              var data = taskList[index];
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return TaskPage(
                                        isMyTask: false,
                                        projectId: data["projectId"],
                                        index:index,
                                        taskName: data["taskname"] ?? " ",
                                        dueDate: data["dueDate"] ?? " ",
                                        isCompleted: data["isCompleted"] ?? false,
                                        taskDescription: data["description"] ?? "no description",
                                        projectOfTask: data["projectOfTask"] ?? " ",
                                        priority: data["priority"] ?? 0,
                                        status: data["status"] ?? 0,
                                        assignedBy: data["assignedBy"] ?? "rohit",
                                        assignedTo: data["assignedTo"] ?? "vikas",
                                        isAssigned: data["isAssigned"] ?? true,
                                        imageUrl: data["attachmentLink"] ?? "",
                                        taskId: data["_id"],
                                        projectName: data["projectName"],
                                      );
                                    }));
                                  },
                                  child:
                                  // TaskListItem(
                                  //   index: index,
                                  //   isChecked:false,
                                  //   dueDate: " ",
                                  //   taskName: "data",
                                  //   taskDescription: " ",
                                  //   taskId:  " ",
                                  //   projectId: widget.projectId,
                                  // )
                                  TaskListItem(
                                    index: index,
                                    isChecked: taskList[index]["isCompleted"] ?? false,
                                    dueDate: taskList[index]["dueDate"] ?? " ",
                                    taskName: data["taskname"],
                                    taskDescription: data["description"],
                                    taskId: taskList[index]["_id"] ?? " ",
                                    projectId: widget.projectId,
                                    isMyTask: false,
                                  )
                                  //  UserTile(thisIsList[index]["fullName"]!)

                                  );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
