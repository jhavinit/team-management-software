import 'package:flutter/material.dart';
import 'package:team_management_software/controller/helper_function.dart';
// import 'shared_pref_functions.dart';
// import 'function_handler.dart';

class Data with ChangeNotifier {
  HelperFunction helperFunction = HelperFunction();
  List listOfMessagesNotifier = [];
  List listOfMyTasksNotifier=[];
  List listOfTokensNotifier = [];
  List listOfProjectsNotifier = [];
  List taskListNotifier = [];
  List taskListOfParticularProjectNotifier=[];
  List taskMembersOfParticularProjectNotifier=[];
  var allDetailsOfProjects={};
  String key = "";
  bool loadingScreen = false;
  bool isLoadingContent = false;
  getTaskListAndMemberListForProject(index){
    //print(taskMembersOfParticularProjectNotifier);
   // print(allDetailsOfProjects);
   taskMembersOfParticularProjectNotifier=allDetailsOfProjects["projects"][index]["members"];
   taskListOfParticularProjectNotifier=allDetailsOfProjects["projects"][index]["tasks"];
    notifyListeners();

  }

  getMyTaskList() async{
    listOfMyTasksNotifier=await helperFunction.getAllTasksOfUser();
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
  updateMyTaskList(index,projectId,taskId,dataToSend){
    listOfMyTasksNotifier[index]["isCompleted"]=!listOfMyTasksNotifier[index]["isCompleted"];
    notifyListeners();
    helperFunction.updateTask(projectId, taskId, dataToSend);

  }

  marksTaskAsComplete({required index,
    required projectId,
    required taskId,
    required isCompleted,
    required isMyTask
  }) {
    if(isMyTask==true){
      listOfMyTasksNotifier[index]["isCompleted"] =
      !listOfMyTasksNotifier[index]["isCompleted"];

    }
    else {
      taskListNotifier[index]["isCompleted"] =
          !taskListNotifier[index]["isCompleted"];
    }
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
      required index,
      required isMyTask})
  async{
    if(isMyTask==true){
      listOfMyTasksNotifier[index]["taskname"] = taskName;
      listOfMyTasksNotifier[index]["taskDescription"] = taskDescription;
      listOfMyTasksNotifier[index]["assignedTo"] = assignedTo;
      listOfMyTasksNotifier[index]["dueDate"] = dueDate;
      listOfMyTasksNotifier[index]["priority"] = priority;
      listOfMyTasksNotifier[index]["status"] = status;
    }
    else
    {
      taskListNotifier[index]["taskname"] = taskName;
      taskListNotifier[index]["taskDescription"] = taskDescription;
      taskListNotifier[index]["assignedTo"] = assignedTo;
      taskListNotifier[index]["dueDate"] = dueDate;
      taskListNotifier[index]["priority"] = priority;
      taskListNotifier[index]["status"] = status;
    }

    notifyListeners();
    await helperFunction.updateTask(projectId, taskId, dataToSend);
  }

  archiveProject(projectId,bool isArchived,int index){
    listOfProjectsNotifier[index]["isArchived"]=isArchived;
    notifyListeners();
   var dataToSend={
      "isArchived":isArchived
    };
    helperFunction.updateProject(projectId: projectId, dataToSend: dataToSend);

  }

  updateIndividualProject(
      {required projectId,
        required projectName,
        required projectDescription,
        required isArchived,
        required isDeleted,
        required dataToSend,
        required index,
        required isFav
      }
      ){
    listOfProjectsNotifier[index]["name"]=projectName;
    listOfProjectsNotifier[index]["description"]=projectDescription;
    listOfProjectsNotifier[index]["isArchived"]=isArchived;
    listOfProjectsNotifier[index]["isActive"]=isDeleted;
    listOfProjectsNotifier[index]["dataToSend"]=dataToSend;
    listOfProjectsNotifier[index]["isFav"]=isFav;

    notifyListeners();
    helperFunction.updateProject(projectId: projectId, dataToSend: dataToSend);

  }

  addTaskToProject(projectId, taskData) async {
    toggleLoading();
    print("adding task to projectId $projectId");
    //send post req to project id
    await helperFunction.addTaskToProject(projectId, taskData);
    //notifyListeners();
    await getTasksListFromServerForProject(projectId);
    toggleLoading();
  }

  addMemberToList(memberName,projectId)async{
    print("adding");
    taskMembersOfParticularProjectNotifier.add({
      "memberName":memberName
    });
    notifyListeners();
    await helperFunction.addMemberToProject(memberName, projectId);
  }



  addTaskInNotifier(
      {required taskName,
      required taskDescription,
      required dueDate,
      required projectId,
        required assignedTo,
        required priority,
        required status
      }) async{

    var newTask = {
      "assignedBy":"User1",
      "taskname": taskName,
      "description": taskDescription ?? "Add description..",
      "isCompleted": false,
      "dueDate": dueDate,
      "priority": priority,
      "status":status,
      "isAssigned": true,
      "assignedTo": assignedTo
    };
    print("adding task to $assignedTo");
    taskListNotifier.add(newTask);
    notifyListeners();
    await addTaskToProject(projectId, newTask);

  }


  toggleLoading() {
    loadingScreen = !loadingScreen;
    notifyListeners();
  }

  updateKey(String newKey) {
    key = newKey;
  }

  addProjectToList(projectDetails) async {
    // listOfProjectsNotifier.add(projectDetails);
    // notifyListeners();
    toggleLoading();
    await helperFunction.addProjectToDatabase(projectDetails);
    await updateProjectListFromServer();
    toggleLoading();
  }

  removeProjectFromList(index) {
    listOfProjectsNotifier.removeAt(index);
    notifyListeners();
  }

  updateProjectListFromServer() async {
   // listOfProjectsNotifier =await helperFunction.getAllProjectDetails2();
   allDetailsOfProjects= await helperFunction.getAllProjectDetails().then((value) {
     // print("the value is $value");
      listOfProjectsNotifier=value["projects"];
      return value;
    });

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
  updateMessageListFromServer(userName,myName) async {
    print("updating message from notifier");
    listOfMessagesNotifier =
        await helperFunction.getAllMessagesByUserName(userName,myName);
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
    print("in the adding list");
    var newMessage = {
      "message": text,
      "sendBy": sendBy,
      "type": type,
      "fileName": fileName,
      // "timeStamp": timeStamp.toString()
    };
    print("the key is $key amd send by is $sendBy");
    // print(newMessage);
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
  //
  // getAllMessagesByUserName(String userName) async {
  //   listOfMessagesNotifier =
  //       await helperFunction.getAllMessagesByUserName(userName);
  //   notifyListeners();
  // }
}
