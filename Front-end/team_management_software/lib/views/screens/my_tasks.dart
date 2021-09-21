import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/src/provider.dart';
import 'package:team_management_software/views/components/new_task.dart';
import 'package:team_management_software/views/components/task_tile.dart';
import 'package:team_management_software/views/task_page.dart';
import '../../change_notifier.dart';

class MyTasks extends StatefulWidget {
  String projectId;
  MyTasks({Key? key, required this.projectId}) : super(key: key);

  @override
  _MyTasksState createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  var taskList;
  bool isLoading = true;

  getTaskList() {
    taskList = context.watch<Data>().taskListNotifier;
  }

  updateTaskList() async {
    await context
        .read<Data>()
        .getMyTaskList();
    isLoading = false;
  }

  @override
  void initState() {

    print(widget.projectId + ".............................................");
    updateTaskList();

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    await getTaskList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          "My Tasks",
          style: TextStyle(
              color: Colors.yellow[800],
              fontWeight: FontWeight.w300,
              fontSize: 25),
        ),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.yellow[800],
                backgroundColor: Colors.black,
              ),
            )
          : taskList.isEmpty
              ? Center(
                  child: Text(
                    "No active task...",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : Container(
                  // padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        padding: EdgeInsets.only(
                            left: 30, top: 8, bottom: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "Tasks",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[800]),
                              ),
                            ),
                            Text(
                              "Due Date",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                            )
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
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return TaskPage(
                                            projectId: data["projectId"],
                                            index: index,
                                            taskName: data["taskname"] ?? " ",
                                            dueDate: data["dueDate"] ?? " ",
                                            isCompleted:
                                                data["isCompleted"] ?? false,
                                            taskDescription:
                                                data["description"] ??
                                                    "no description",
                                            projectOfTask:
                                                data["projectOfTask"] ?? " ",
                                            priority: data["priority"] ?? 1,
                                            status: data["status"] ?? 2,
                                            assignedBy:
                                                data["assignedBy"] ?? "rohit",
                                            assignedTo:
                                                data["assignedTo"] ?? "vikas",
                                            isAssigned:
                                                data["isAssigned"] ?? true,
                                            imageUrl:
                                                data["attachmentLink"] ?? "",
                                            taskId: data["_id"] ?? "",
                                          );
                                        }));
                                      },
                                      child:
                                      TaskListItem(
                                        index: index,
                                        isChecked: taskList[index]["isCompleted"] ?? false,
                                        dueDate: taskList[index]["dueDate"] ?? " ",
                                        taskName: data["taskname"],
                                        taskDescription: data["description"],
                                        taskId: taskList[index]["_id"] ?? " ",
                                        projectId: widget.projectId,
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
      // Column(
      //  mainAxisAlignment: MainAxisAlignment.start,
      //   children: [
      //     TaskListItem(),
      //     TaskListItem()
      //   ],
      // ),
    );
  }
}
