import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpFunctions{

  registerNewAdmin(
      {String? name,
      String? username,
      String? email,
      String ?password,
      String ?passwordConfirm,
      String ?role,
      String ?activationToken,
      int ?phoneNumber,
      String ?companyName,
      String? companyEmail,
      int ?companyNumber,
      String ?companyDescription,
      String ?address}) async{
    print("register user called");
    var url=Uri.parse("https://ems-heroku.herokuapp.com/register");
    var dataToSend={
      "name":name,
      "username":username,
      "email":email,
      "password":password,
     "passwordConfirm":passwordConfirm,
      "role":role,
      "activation_token":activationToken,
      "phoneNumber":phoneNumber,
      "companyName":companyName,
      "companyEmail":companyEmail,
      "companyNumber":companyNumber,
      "companyDescription":companyDescription,
      "address":address
    };
    var finalData=jsonEncode(dataToSend);
    http.Response response=await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: finalData
    );
    print("this is response");
    print(response.body);
    return response.body;
  }

  signInUser({
    String? username,String? password,required role
}) async{

    print("signInUser called with $username and $password");
    var urlUser=Uri.parse("https://ems-heroku.herokuapp.com/users/login");
    var urlAdmin=Uri.parse("https://ems-heroku.herokuapp.com/login");
    var dataToSend={
      "username":username,
      "password":password,
    };
    var finalData=jsonEncode(dataToSend);
    http.Response response=await http.post(role=="admin"?urlUser:urlAdmin,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: finalData
    );
    print("this is response");
    print(response.body);
    return response.body;
  }

  registerNewUser(
      {String ?name,
      String ?username,
      String ?email,
      String ?password,
      String ?passwordConfirm,
      String ?designation,
      String ?token}) async{

    print("Registering new user with token $token");
    var url=Uri.parse("https://ems-heroku.herokuapp.com/users/register");
    var dataToSend={
      "fullName":  name,
      "username":username,
      "email":email,
      "password":password,
      "passwordConfirm":passwordConfirm,
      "designation":designation,
      "token":token
      // "efOjZLfxSKCs7NneDEDZNN:APA91bG0ctBRv5gJPvfQ5jqpQAcbtCbRFN3v-uTUq9oMzGMsZACGDnQg"
      //     "cH7FwLs32UUnPNfQ3wUhR5aHxRyZvkAWMeHm_UuaUByaF3n_PL6RQbe6RLd-ucuvYJ2luO3e9g9QUo-Sqreb",
    };
    var finalData=jsonEncode(dataToSend);
    var response=await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: finalData
    );

    print("the response form sending user details is ${response.statusCode}");
    print(response.body);
    var data=response.body;
    var dataDecoded=jsonDecode(data);
    print(dataDecoded["status"]);
    return dataDecoded["status"];

  }


}