import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/src/provider.dart';
import 'package:team_management_software/views/components/new_task.dart';
import 'package:team_management_software/views/components/task_tile.dart';
import 'package:team_management_software/views/task_page.dart';
import '../../change_notifier.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyTasks extends StatefulWidget {
  String projectId;
  MyTasks({Key? key, required this.projectId}) : super(key: key);

  @override
  _MyTasksState createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  bool showCompleted=false;
  var taskList;
  bool isLoading = false;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  getTaskList() {
    taskList = context.watch<Data>().listOfMyTasksNotifier;
  }

  refreshFunction() async {
    print("refreshing");
    await updateTaskList();
    _refreshController.refreshCompleted();
  }

  updateTaskList() async {
    await context.read<Data>().getMyTaskList();
    isLoading = false;
  }

  @override
  void initState() {
    print(widget.projectId + "...........");
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
      appBar: AppBar(
        actions: [
          IconButton(
              tooltip: "Show Archived",
              padding: EdgeInsets.only(right: 20),
              onPressed: () {
                setState(() {
               showCompleted=!showCompleted;
                });
                var snackBar = SnackBar(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      //MediaQuery.of(context).size.width / 3,
                      bottom: 10),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.teal[600],
                  content: Text(
                    showCompleted
                       ? "Showing all Tasks"
                       :
                  "Completed Tasks are hidden",
                    style: const TextStyle(fontSize: 14),
                  ),
                  duration: const Duration(milliseconds: 1200),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: Icon(
               !showCompleted ?
               Icons.visibility_outlined :
                Icons.visibility,
                size: 25,
                color: Colors.yellow[800],
              )),
        ],
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
          :
          SmartRefresher(controller: _refreshController,
            enablePullDown: true,
            onRefresh: refreshFunction,
            onLoading: refreshFunction,
            header: CustomHeader(
              refreshStyle: RefreshStyle.UnFollow,
              height: 20,
              builder: (context, mode) {
                if (mode == RefreshStatus.refreshing) {
                  return Container(
                    height: 20,
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          color: Colors.yellow[800],
                          backgroundColor: Colors.black,
                          minHeight: 4,
                        ),
                        // Expanded(child: Container())
                      ],
                    ),
                  );
                }
                else if (mode == RefreshStatus.idle) {
                  return Container(
                    child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("pull to refresh"),
                          Icon(Icons.arrow_downward)
                        ]),
                  );
                }

                return Container();
              },
            ),
          child:

      taskList.isEmpty
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
                                  return
                                  !showCompleted?
                                      !data["isCompleted"]?

                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return TaskPage(
                                            isMyTask: true,
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
                                            projectName: data["projectName"],
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
                                        isMyTask: true,
                                      )

                                      //  UserTile(thisIsList[index]["fullName"]!)

                                      ):Container()
                                          :GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                      return TaskPage(
                                                        isMyTask: true,
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
                                                        projectName: data["projectName"],
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
                                            isMyTask: true,
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
    )
    );
  }
}
