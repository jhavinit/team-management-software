import 'package:http/http.dart' as http;
//import 'package:learning_notifications/constants.dart';
import 'dart:convert';
import 'package:team_management_software/constants.dart';

class HelperFunction {
  // final FirebaseAuth _auth=FirebaseAuth.instance;
  // User1 _userFromFirebaseUser(User? user){                    //didn't get this, need to work on it
  //   return user!=null ? User1(userId: user.uid):null;
  // }
  // Future signUpWithEmailAndPassword(String email, String password) async{
  //   try{
  //     UserCredential result= await _auth.createUserWithEmailAndPassword
  //       (email: email, password: password);
  //     User? firebaseUser =result.user;
  //     return firebaseUser;
  //   }catch(e){
  //     print(e.toString());
  //   }
  // }
  // Future signInWithEmailAndPassword(String email, String password) async{
  //   try{
  //     UserCredential result = await _auth.signInWithEmailAndPassword //usercredential is built in imported package
  //       (email: email, password: password);
  //     User? firebaseUser= result.user;
  //     return firebaseUser;
  //   }catch(e){
  //     print(e.toString());
  //
  //   }
  // }

  sendNotification(String? token, String? message, String? name, String type,
      String fileName, timeStamp) async {
    //print("$token $message $name");
    print("Sending notification function");
    if (type == "unsend") {
      //print("the type is unsend");
      //print(" $token, $message,$name, $type, $fileName, $timeStamp");
    }
    if (message != "" || type == "unsend") {
      http.Response response = await http.get(Uri.parse(
          "https://node-notification.herokuapp.com/sendToken?token="
          "$token&message=$message&name=${Constants.email}&type=$type&fileName=$fileName&timeStamp=${timeStamp.toString()}"));
      //print('notification sent');
      print('your response is ${response.statusCode}');
    }
  }

  sendDeviceTokenToDatabase() async {
    var url = Uri.parse("https://ems-heroku.herokuapp.com/users/register");
    var dataToSend = {
      "fullName": "Rohit",
      "username": "rohitUser",
      "email": "rohit@gmail.com",
      "password": "rohit123",
      "passwordConfirm": "rohit123",
      "designation": "developer",
      "token":
          "efOjZLfxSKCs7NneDEDZNN:APA91bG0ctBRv5gJPvfQ5jqpQAcbtCbRFN3v-uTUq9oMzGMsZACGDnQg"
              "cH7FwLs32UUnPNfQ3wUhR5aHxRyZvkAWMeHm_UuaUByaF3n_PL6RQbe6RLd-ucuvYJ2luO3e9g9QUo-Sqreb",
    };
    var finalData = jsonEncode(dataToSend);
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: finalData);
    print("the response form sending user details is ${response.statusCode}");
    print(response.body);
  }

  Future getAllTokens() async {
    http.Response response =
        await http.get(Uri.parse("https://ems-heroku.herokuapp.com/users"));
    String data = response.body;
    var finalData = jsonDecode(data);
    //print("this is from handler$finalData");
    print("the response code from get all tokens");
    print(response.statusCode);
    return finalData["users"];
  }

  sendNotificationTrial(String? sender, String? receiver, String? message) async {
    //senderUsername , receiverUsername , message

    print("Sending notification function");
    var data={
      "sender":"rohit8",
      "receiver":receiver,
      "message":message,
    };
    var finalData=jsonEncode(data);
    var url=Uri.parse("https://ems-heroku.herokuapp.com/message/sendMessage");

    var response=await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: finalData,
   );
    print("the final data is $data");
    print('your response is ${response.body}');
    // }
  }
  getAllMessagesByUserName(String userName) async{

    var data={
      "sender":"rohit8",
      "receiver":userName,
    };
    var finalData=jsonEncode(data);
    var url=Uri.parse("https://ems-heroku.herokuapp.com/message/getAllMessages");
    var response=await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: finalData,
    );
    var returnedData=  jsonDecode(response.body);
    print("the returned data") ;
    print(returnedData["chats"]) ;
    return returnedData["chats"];

  //  print('your response from get user by username ${response.body}');
  }

  Future getAllProjectDetails() async {
    http.Response response =
        await http.get(Uri.parse("https://ems-heroku.herokuapp.com/projects"));
    var data = response.body;
    var finalData = jsonDecode(data);
    // print(finalData["message"]);
    print("the response from get all projects is ${response.statusCode}");
    return finalData;
  }
  Future getAllProjectDetails2() async {
    http.Response response =
    await http.get(Uri.parse("https://ems-heroku.herokuapp.com/projects"));
    var data = response.body;
    var finalData = jsonDecode(data);
    // print(finalData["message"]);
    print("the response from get all projects is ${response.statusCode}");
    return finalData["message"];
  }

  Future addProjectToDatabase(dataToSend) async {
    print("adding a project was called");
    var url = Uri.parse("https://ems-heroku.herokuapp.com/projects");
    var finalData = jsonEncode(dataToSend);
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: finalData);
    print("response ${response.body}");
  }

  Future addTaskToProject(projectId, dataToSend) async {
    print("adding a task was called");
    var url =
        Uri.parse("https://ems-heroku.herokuapp.com/projects/$projectId/tasks");
    var finalData = jsonEncode(dataToSend);
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: finalData);
    print("response ${response.body} from the adding task..........");
  }

  updateTask(projectId,taskId,dataToSend)async{
    print("updating  a task............");

  //   var tempData={
  //     "description":"Changed Desc",
  //     "isCompleted":false,
  //     "taskname":"again 3.0",
  //     "dueDate":"2021-10-20T00:00:00.000Z",
  //     "priority":1,
  //     "status":3,
  //     "assignedTo":"rohit 2.0",
  //     "assignedBy":"vikas 2.0",
  //     "isAssigned":true
  //   };
  //
  //   //dataToSend=tempData;
  // //  projectId="61363c167582bc0023ccacae";
  // //  taskId="6141994843f4d30023066825";
    var url =
    Uri.parse("https://ems-heroku.herokuapp.com/projects/$projectId/tasks/$taskId");
    var finalData = jsonEncode(dataToSend);
    var response = await http.patch(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: finalData);
    print("response ${response.body} from the adding project..........");
  }



  updateProject({required projectId, required dataToSend})async{
    print("updating a project");
    var url =
    Uri.parse("https://ems-heroku.herokuapp.com/projects/$projectId");
    var finalData = jsonEncode(dataToSend);
    var response = await http.patch(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: finalData);
    print("response ${response.body} from the adding project..........");

  }

  Future getAllTasksWithProjectId(projectId) async {
    http.Response response = await http.get(Uri.parse(
        "https://ems-heroku.herokuapp.com/projects/$projectId/tasks"));
    String data = response.body;
    var finalData = jsonDecode(data);
    //print("this is from handler$finalData");
    print("the response code from get all tasks of a project");
    print(response.statusCode);
    return finalData["allTasks"];
  }
}
//"https://node-notification.herokuapp.com/sendToken?token=$token&message=$message&name=$name"
//http://192.168.29.199:4000?token=$token&message=$message&jsonDataTrial=$finalJsonData
//http://192.168.29.199:4000?token=cNPOWQRrScGMigqHfK6E15:APA91bEgwAvG1dKISZ-QnvOgphVH7I2ri2sle8AoZT0laHIyjCe83FpOg6ttsirL15QaYsUyXL2yJDEYuT8rhSK2HcJCDYHj6kYt8xxu1Y8bN0Xm0fzyvDUFR2LR5Ak0rMwcgV3LG0g7&message=meramsg&name=rohit
