// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/src/provider.dart';
import 'package:team_management_software/controller/helper_function.dart';
import 'package:team_management_software/views/components/new_project.dart';
import 'package:team_management_software/views/project_page.dart';
import 'package:team_management_software/views/screens/my_tasks.dart';
import 'package:team_management_software/views/task_list_screen.dart';
import 'package:team_management_software/views/test_screen.dart';
import '../change_notifier.dart';
import '../constants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({Key? key}) : super(key: key);
  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  var fabController = ScrollController();
  bool fabIsVisible = true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final RefreshController _refreshController2 =
      RefreshController(initialRefresh: false);
  bool isLoaded = false;
  bool loadingScreen = false;
  bool showArchived = false;
  var projects;
  String input = "";
  HelperFunction helperFunction = HelperFunction();

  gettingTheList() async {
    projects = context.watch<Data>().listOfProjectsNotifier;
    loadingScreen = context.watch<Data>().loadingScreen;
  }

  // getConversationList() async {
  //   var thisIsList = context.watch<Data>().listOfTokensNotifier;
  // }

  archiveProject(id, isArchived, index) {
    context.read<Data>().archiveProject(id, isArchived, index);
  }

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
    await context.read<Data>().updateProjectListFromServer();
    await context.read<Data>().getTokensDataFromHttp();
    await context.read<Data>().getMyTaskList();
  }

  @override
  void didChangeDependencies() async {
    //await getConversationList()
    await gettingTheList();
    isLoaded = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fabController.dispose();
  }

  @override
  void initState() {
    fabController.addListener(() {
      setState(() {
        fabIsVisible = fabController.position.userScrollDirection ==
            ScrollDirection.forward;
      });
    });
    super.initState();
    print("hello");
    updatingTheList();
  }

  onProjectItemMenuTap() {}
  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = projects.removeAt(oldindex);
      projects.insert(newindex, items);
    });
  }

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
                        right: MediaQuery.of(context).size.width / 5,
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
                  !showArchived ? Icons.visibility_outlined : Icons.visibility,
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
        floatingActionButton: Visibility(
            child: CreateNewProject(), visible: fabIsVisible ? true : false),
        //floatingButtonForNewProject(context),

        body: loadingScreen
            ? Center(
                child: Container(
                width: MediaQuery.of(context).size.width / 1.3,
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
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Colors.yellow[800],
                          backgroundColor: Colors.black,
                        ))
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
                                      ? Container(
                                          // padding: EdgeInsets.all(40),
                                          // child:  Text("archived project")
                                          )
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
                                        )
                                  : CardForProject(
                                      name: projects[index]["name"] ?? "name",
                                      description: projects[index]
                                              ["description"] ??
                                          "description",
                                      projectId: projects[index]["_id"],
                                      index: index,
                                      isArchived: projects[index]["isArchived"],
                                    );
                            },
                          ),
                        ),

                  projects.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Colors.yellow[800],
                          backgroundColor: Colors.black,
                        ))
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
<<<<<<< Updated upstream
                            // controller: fabController,
=======
                            //  controller: fabController,
>>>>>>> Stashed changes
                            shrinkWrap: true,
                            //onReorder: reorderData,
                            itemCount: projects.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return !showArchived
                                  ? projects[index]["isArchived"]
                                      ? Container()
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
                                              isFav: projects[index]["isFav"],
                                            )
                                          : Container()
                                  : projects[index]["isFav"] ?? false
                                      ? CardForProject(
                                          name:
                                              projects[index]["name"] ?? "name",
                                          description: projects[index]
                                                  ["description"] ??
                                              "description",
                                          projectId: projects[index]["_id"],
                                          index: index,
                                          isArchived: projects[index]
                                              ["isArchived"],
                                          isFav:
                                              projects[index]["isFav"] ?? false,
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

class CardForProject extends StatelessWidget {
  final index;
  final name;
  final description;
  final projectId;
  final isArchived;
  final isFav;
  const CardForProject(
      {Key? key,
      this.name,
      this.description,
      this.projectId,
      this.index,
      this.isArchived,
      this.isFav})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      alignment: Alignment.center,
      child: Card(
        //color: Colors.orange[50],
        shadowColor: Colors.grey[500],

        //elevation: 2,
        //margin: EdgeInsets.all(5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          // contentPadding: EdgeInsets.only(left: 20,right:10,top:12,bottom: 10),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TaskListScreen(
                        projectId: projectId,
                        projectName: name,
                      );
                      //TaskListScreen(name: name,);
                    }));
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w400)),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          description,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: LinearProgressIndicator(
                                  minHeight: 3,
                                  value: 0.7,
                                  color: Colors.yellow[800],
                                  backgroundColor: Colors.black,
                                ),
                              ),
                              Expanded(flex: 1, child: Container())
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
<<<<<<< Updated upstream
                Container(
                  child: PopupMenuButton<String>(
                    onSelected: (String value) {
                      if (value == "Details") {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProjectPage(
                            projectId: projectId,
                            index: index,
                            projectName: name,
                            projectDescription: description,
                            isArchived: isArchived,
                            isFav: isFav ?? false,
                          );
                        }));
                      } else if (value == "fav") {
                        // todo add this to fav
=======
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == "Details") {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ProjectPage(
                              projectId: projectId,
                              index: index,
                              projectName: name,
                              projectDescription: description,
                              isArchived: isArchived,
                              isFav: isFav ?? false,
                            );
                          }));
                        } else if (value == "fav") {
                          // todo add this to fav
>>>>>>> Stashed changes

                        }
                      },
                      icon: const Icon(
                        Icons.more_horiz,
                        size: 30,
                      ),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        // const PopupMenuItem<String>(
                        //   value: 'fav',
                        //   child: Text('Add to Favourites'),
                        // ),
                        const PopupMenuItem<String>(
                          value: 'Details',
                          child: Text('Details'),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                     // padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    //  height: 30,width: 50,
                      // decoration: BoxDecoration(
                      //   shape: BoxShape.rectangle,
                      //   color: Colors.black,
                      //   borderRadius: BorderRadius.circular(14)
                      // ),
                      child: Text(
                      "70 %",
                      style: TextStyle(
                        color: Colors.yellow[800],
                       // fontWeight: FontWeight.bold,
                        letterSpacing: -0.5),
                      ),
                    )
                  ],
                ),
                // IconButton(
                //   icon: const Icon(Icons.menu),
                //   onPressed: () {
                //
                //   },
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
