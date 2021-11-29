// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/src/provider.dart';
import 'package:team_management_software/controller/helper_function.dart';
import 'package:team_management_software/views/components/new_project.dart';
import 'package:team_management_software/views/project_page.dart';
import 'package:team_management_software/views/task_list_screen.dart';
import '../change_notifier.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../constants.dart';
import 'components/card_project.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({Key? key}) : super(key: key);
  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  //var fabController = ScrollController();
  //bool fabIsVisible = true;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  final RefreshController _refreshController2 =
  RefreshController(initialRefresh: false);
  bool isLoaded = false;
  bool creatingProject = false;
  bool showArchived = false;
  var projects;
  String input = "";
  HelperFunction helperFunction = HelperFunction();

  gettingTheList() async {
    mounted ? projects = context
        .watch<Data>()
        .listOfProjectsNotifier : null;
    mounted ? creatingProject = context
        .watch<Data>()
        .loadingScreen : null;
  }

  // getConversationList() async {
  //   var thisIsList = context.watch<Data>().listOfTokensNotifier;
  // }
  //
  // archiveProject(id, isArchived, index) {
  //   context.read<Data>().archiveProject(id, isArchived, index);
  // }

  refreshFunction() async {
    print("refreshing");
    await updatingTheList();
    // Future.delayed(Duration(seconds: 5));
    _refreshController.refreshCompleted();
  }

  refreshFunction2() async {
    print("refreshing");
    await updatingTheList();
    // Future.delayed(Duration(seconds: 5));
    _refreshController2.refreshCompleted();
  }

  removingFromList(index) {}

  updatingTheList() async {
    try {
      mounted ? await context.read<Data>().updateProjectListFromServer() : null;
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoaded = true;
    });


    try {
      mounted ? await context.read<Data>().getTokensDataFromHttp() : null;
    } catch (e) {
      print(e);
    }


    mounted ? await context.read<Data>().getMyTaskList() : null;
  }

  @override
  void didChangeDependencies() async {
    mounted ? await gettingTheList() : null;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _refreshController.dispose();
    _refreshController2.dispose();
    //fabController.dispose();
  }

  @override
  void initState() {
    // fabController.addListener(() {
    //   setState(() {
    //     fabIsVisible = fabController.position.userScrollDirection ==
    //         ScrollDirection.forward;
    //   });
    // });
    super.initState();
    print("hello");

    mounted ? updatingTheList() : null;
  }

    // onProjectItemMenuTap() {}
    // void reorderData(int oldindex, int newindex) {
    //   setState(() {
    //     if (newindex > oldindex) {
    //       newindex -= 1;
    //     }
    //     final items = projects.removeAt(oldindex);
    //     projects.insert(newindex, items);
    //   });
    // }



    @override
    Widget build(BuildContext context) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            // toolbarHeight: 35,
            leadingWidth: 30,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  tooltip: "Show Archived",
                  padding: EdgeInsets.only(right: 20),
                  onPressed: () {
                    setState(() {
                      showArchived = !showArchived;
                    });
                    var snackBar = SnackBar(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      margin: EdgeInsets.only(
                          left: 10,
                          right: MediaQuery
                              .of(context)
                              .size
                              .width / 5,
                          bottom: 5),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.teal[600],
                      content: Text(
                        showArchived
                            ? "Archived Projects are visible"
                            : "Archived Projects are Hidden",
                        style: const TextStyle(fontSize: 14),
                      ),
                      duration: const Duration(milliseconds: 1200),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  icon: Icon(
                    !showArchived ? Icons.visibility_outlined : Icons
                        .visibility,
                    size: 25,
                    color: Colors.yellow[800],
                  )),
              IconButton(
                  tooltip: "More",
                  padding: EdgeInsets.only(right: 20),
                  onPressed: () {},
                  icon: Icon(
                    // !showArchived?
                    Icons.more_vert_outlined,
                    size: 30,
                    color: Colors.yellow[800],
                  ))
            ],

            title: Text(
              "Projects",
              style: TextStyle(
                  color: Colors.yellow[800],
                  fontWeight: FontWeight.w300,
                  fontSize: 25),
            ),
            backgroundColor: Colors.black,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(30),
              child: Container(
                alignment: Alignment.topLeft,
                child: TabBar(
                  indicatorWeight: 3,
                  indicatorColor: Colors.yellow[800],
                  isScrollable: true,
                  tabs: [
                    Container(
                      //width: 50,
                        child: Tab(
                          text: 'All',
                          //height: 40,
                        )),
                    Tab(
                      text: 'Favourites',
                    ),
                    Tab(
                      text: 'Recents',
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Constants.role == "admin"
              ? CreateNewProject()
              : null,
          //floatingButtonForNewProject(context),

          body: !isLoaded && projects.isEmpty
              ? Center(
              child: CircularProgressIndicator(
                color: Colors.yellow[800],
                backgroundColor: Colors.black,
              ))
              : creatingProject
              ? Center(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 1.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // LinearProgressIndicator(
                    //
                    //   color: Colors.yellow[800],
                    //   backgroundColor: Colors.black,
                    // ),
                    Container(
                        padding: EdgeInsets.only(bottom: 16, top: 16),
                        child: Text(
                          "Creating a project... ",
                          style: TextStyle(
                              color: Colors.yellow[800],
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        )),
                    LinearProgressIndicator(
                      color: Colors.yellow[800],
                      backgroundColor: Colors.black,
                    ),
                  ],
                ),
              ))
              : TabBarView(
            children: [
              projects.isEmpty
                  ?
              // Center(
              //         child: CircularProgressIndicator(
              //         color: Colors.yellow[800],
              //         backgroundColor: Colors.black,
              //       ))
              Center(
                child: Text(
                  "You aren't added to any project...",
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : SmartRefresher(
                controller: _refreshController,
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
                    } else if (mode == RefreshStatus.idle) {
                      return Container(
                        child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text("pull to refresh"),
                              Icon(Icons.arrow_downward)
                            ]),
                      );
                    }

                    return Container();
                  },
                ),
                child: ListView.builder(
                  //controller: fabController,
                  shrinkWrap: true,
                  //onReorder: reorderData,
                  itemCount: projects.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return !showArchived
                        ? projects[index]["isArchived"]
                        ? Container()
                        : CardForProject(
                        name: projects[index]["name"] ??
                            "name",
                        description: projects[index]
                        ["description"] ??
                            "description",
                        projectId: projects[index]["_id"],
                        index: index,
                        isArchived: projects[index]
                        ["isArchived"],
                        completionRatio: projects[index]
                        ["completionRatio"])
                        : CardForProject(
                        name:
                        projects[index]["name"] ?? "name",
                        description: projects[index]
                        ["description"] ??
                            "description",
                        projectId: projects[index]["_id"],
                        index: index,
                        isArchived: projects[index]
                        ["isArchived"],
                        completionRatio: projects[index]
                        ["completionRatio"]);
                  },
                ),
              ),
              //next tab bar view for the favourites section
              projects.isEmpty
                  ? Center(
                child: Text(
                  "No project marked as favourite...",
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : SmartRefresher(
                controller: _refreshController2,
                enablePullDown: true,
                onRefresh: refreshFunction2,
                onLoading: refreshFunction2,
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
                    } else if (mode == RefreshStatus.idle) {
                      return Container(
                        child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: const [
                              Text("pull to refresh"),
                              Icon(Icons.arrow_downward)
                            ]),
                      );
                    }

                    return Container();
                  },
                ),
                child: ListView.builder(
                  //  controller: fabController,
                  shrinkWrap: true,
                  //onReorder: reorderData,
                  itemCount: projects.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return !showArchived
                        ? projects[index]["isArchived"]
                        ? Container()
                        : projects[index]["isFav"] ?? false
                        ? CardForProject(
                      name: projects[index]
                      ["name"] ??
                          "name",
                      description: projects[index]
                      ["description"] ??
                          "description",
                      projectId: projects[index]
                      ["_id"],
                      index: index,
                      isArchived: projects[index]
                      ["isArchived"],
                      isFav: projects[index]
                      ["isFav"],
                      completionRatio: projects[
                      index]
                      ["completionRatio"] ??
                          1,
                    )
                        : Container()
                        : projects[index]["isFav"] ?? false
                        ? CardForProject(
                      name: projects[index]["name"] ??
                          "name",
                      description: projects[index]
                      ["description"] ??
                          "description",
                      projectId: projects[index]["_id"],
                      index: index,
                      isArchived: projects[index]
                      ["isArchived"],
                      isFav: projects[index]["isFav"] ??
                          false,
                      completionRatio: projects[index]
                      ["completionRatio"] ??
                          -1,
                    )
                        : Container();
                  },
                ),
              ),
              //third child for tab view
              Container()
            ],
          ),
        ),
      );
    }

}

