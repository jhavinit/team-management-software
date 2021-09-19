import 'package:flutter/material.dart';
import 'package:team_management_software/controller/helper_function.dart';
// import 'shared_pref_functions.dart';
// import 'function_handler.dart';

class Data with ChangeNotifier {
  HelperFunction helperFunction = HelperFunction();
  List listOfMessagesNotifier = [];
  List listOfTokensNotifier = [];
  List listOfProjectsNotifier = [];
  List taskListNotifier = [
    // {
    //   "taskname": "trialTask",
    //   "description": "desc",
    //   "isCompleted": false,
    //   "isArchived": false,
    //   "isAssigned": true,
    //   "assignedTo": "Vikash",
    //   "assignedBy": "Rohit",
    //   "dueDate": "2021-10-20T00:00:00.000Z",
    //   "priority": 1,
    //   "status": 2,
    // }
  ];
  List taskListOfParticularProjectNotifier=[];
  List taskMembersOfParticularProjectNotifier=[];
  var allDetailsOfProjects;
  getTaskListAndMemberListForProject(index){
    print(taskMembersOfParticularProjectNotifier);
    taskMembersOfParticularProjectNotifier=allDetailsOfProjects["message"][index]["members"];
    taskListOfParticularProjectNotifier=allDetailsOfProjects["message"][index]["tasks"];
    notifyListeners();

  }

  getTasksListFromServerForProject(projectId) async {
    taskListNotifier = await helperFunction.getAllTasksWithProjectId(projectId);
    notifyListeners();
  }

  updateTaskList(index, projectId, taskId, dataToSend) {
    print("updating $index");
    taskListNotifier[index]["isCompleted"] =
        !taskListNotifier[index]["isCompleted"];
    notifyListeners();
    //send a patch req   /projects/id/tasks/taskId
    helperFunction.updateTask(projectId, taskId, dataToSend);
  }

  marksTaskAsComplete({required index,
    required projectId,
    required taskId,
    required isCompleted
  }) {
    taskListNotifier[index]["isCompleted"]= !taskListNotifier[index]["isCompleted"];
    notifyListeners();
    var dataToSend={
      "isCompleted":isCompleted
    };
    helperFunction.updateTask(projectId, taskId, dataToSend);
  }

  updateIndividualTask (
      {required projectId,
      required taskId,
      required dataToSend,
      required taskName,
      required taskDescription,
      required assignedTo,
      required dueDate,
      required priority,
      required status,
      required index})
  async{
    taskListNotifier[index]["taskname"] = taskName;
    taskListNotifier[index]["taskDescription"] = taskDescription;
    taskListNotifier[index]["assignedTo"] = assignedTo;
    taskListNotifier[index]["dueDate"] = dueDate;
    taskListNotifier[index]["priority"] = priority;
    taskListNotifier[index]["status"] = status;

    notifyListeners();
    await helperFunction.updateTask(projectId, taskId, dataToSend);
  }


  updateIndividualProject(
      {required projectId,
        required projectName,
        required projectDescription,
        required isArchived,
        required isDeleted,
        required dataToSend,
        required index}
      ){
    listOfProjectsNotifier[index]["name"]=projectName;
    listOfProjectsNotifier[index]["description"]=projectDescription;
    listOfProjectsNotifier[index]["isArchived"]=isArchived;
    listOfProjectsNotifier[index]["isActive"]=isDeleted;
    listOfProjectsNotifier[index]["dataToSend"]=dataToSend;

    notifyListeners();
    helperFunction.updateProject(projectId: projectId, dataToSend: dataToSend);

  }

  addTaskToProject(projectId, taskData) async {
    print("adding task to projectId $projectId");
    //send post req to project id
    await helperFunction.addTaskToProject(projectId, taskData);
    notifyListeners();
    await getTasksListFromServerForProject(projectId);
  }

  addTaskInNotifier(
      {required taskName,
      required taskDescription,
      required dueDate,
      required projectId,
        required assignedTo,
        required priority,
        required status
      }) {
    var newTask = {
      "assignedBy":"newUser",
      "taskname": taskName,
      "description": taskDescription ?? "not added",
      "isCompleted": false,
      "dueDate": dueDate,
      "priority": priority,
      "status":status,
      "isAssigned": true,
      "assignedTo": assignedTo
    };
    print("adding task");

    taskListNotifier.add(newTask);
    notifyListeners();
    addTaskToProject(projectId, newTask);
  }

  String key = "";
  bool loadingScreen = false;
  bool isLoadingContent = false;
  toggleLoading() {
    loadingScreen = !loadingScreen;
    notifyListeners();
  }

  updateKey(String newKey) {
    key = newKey;
  }

  addProjectToList(projectDetails) async {
    listOfProjectsNotifier.add(projectDetails);
    notifyListeners();
    await helperFunction.addProjectToDatabase(projectDetails);
    await updateProjectListFromServer();
  }

  removeProjectFromList(index) {
    listOfProjectsNotifier.removeAt(index);
    notifyListeners();
  }

  updateProjectListFromServer() async {
    listOfProjectsNotifier =await helperFunction.getAllProjectDetails2();
    var tempList= await helperFunction.getAllProjectDetails();
    allDetailsOfProjects=tempList;print(allDetailsOfProjects["message"][0]["tasks"]);

    // taskListOfParticularProjectNotifier=tempList["message"]["tasks"];
    // taskMembersOfParticularProjectNotifier=tempList["message"]["members"];
    notifyListeners();
  }

  updateTokenListFromSharedPref() async {
    // listOfTokensNotifier =
    // await SecureStorageFunction.getTokensDataFromSharedPrefs();
    // notifyListeners();
  }

  updateMessageListFromSharedPref(String key) async {
    // listOfMessagesNotifier =
    // await SecureStorageFunction.getDataFromSharedPref(key);
    // notifyListeners();
  }
  updateMessageListFromServer(userName) async {
    print("updating message from notifier");
    listOfMessagesNotifier =
        await helperFunction.getAllMessagesByUserName(userName);
    notifyListeners();
  }

  addToUniqueList(text, key) {
    //print("func called");
    listOfMessagesNotifier.add(text);
    notifyListeners();
    // SecureStorageFunction.saveDataToSharedPref(listOfMessagesNotifier, key);
  }

  addToUniqueListFromServer(
      text, String type, String sendBy, String fileName) async {
    // listOfMessagesNotifier=[{"msg":"first text"}];
    var newMessage = {
      "message": text,
      "sendBy": sendBy,
      "type": type,
      "fileName": fileName,
      // "timeStamp": timeStamp.toString()
    };
    //print(newMessage);
    if (key == sendBy) {
      listOfMessagesNotifier.add(newMessage);
      notifyListeners();
      //   await SecureStorageFunction.saveDataToSharedPref(
      //       listOfMessagesNotifier, from);
      // } else {
      //   var tempList = await SecureStorageFunction.getDataFromSharedPref(from);
      //   tempList.add(newMessage);
      //   await SecureStorageFunction.saveDataToSharedPref(tempList, from);
      // }
    }
  }

  removingMessage(int index, String key) {
    //print("removing a message function");
    listOfMessagesNotifier.removeAt(index);
    notifyListeners();
    // SecureStorageFunction.saveDataToSharedPref(listOfMessagesNotifier, key);
    //send a notification to remove
  }

  removingMessageFromServer(String timeStamp, String from) async {
    //print("removing message from server");
    if (key == from) {
      listOfMessagesNotifier
          .removeWhere((element) => element["timeStamp"] == timeStamp);
      notifyListeners();
      //   await SecureStorageFunction.saveDataToSharedPref(
      //       listOfMessagesNotifier, from);
      // } else {
      //   var tempList = await SecureStorageFunction.getDataFromSharedPref(from);
      //   tempList.removeWhere((element)=>element["timeStamp"]==timeStamp);
      //   await SecureStorageFunction.saveDataToSharedPref(tempList, from);
      // }
    }
  }

  //List get getlist => listOfMessagesNotifier;

  getTokensDataFromHttp() async {
    listOfTokensNotifier = await helperFunction.getAllTokens();
    notifyListeners();
    // await SecureStorageFunction.saveTokensDataToSharedPrefs(
    //     listOfTokensNotifier);
  }

  getAllMessagesByUserName(String userName) async {
    listOfMessagesNotifier =
        await helperFunction.getAllMessagesByUserName(userName);
    notifyListeners();
  }
}
