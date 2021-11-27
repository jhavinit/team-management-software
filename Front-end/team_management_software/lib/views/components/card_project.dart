import 'package:flutter/material.dart';

import '../project_page.dart';
import '../task_list_screen.dart';

class CardForProject extends StatelessWidget {

  final index;
  final name;
  final description;
  final projectId;
  final isArchived;
  final isFav;
  var completionRatio;
  CardForProject(
      {Key? key,
        this.name,
        this.description,
        this.projectId,
        this.index,
        this.isArchived,
        this.isFav,
        required this.completionRatio})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("the completionRatio is $completionRatio");
    var temp=completionRatio*100;
    String completePercent=(temp.toInt()).toString();
    if(completionRatio==-1){
      completePercent="No Task";
    }

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
                                  value:
                                  completionRatio==-1?0.0:completionRatio+0.0,
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
                      child: Text(
                        completePercent=="No Task"?"No Task":
                       "$completePercent %",
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