import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:team_management_software/controller/shared_prefernce_functions.dart';
import 'package:team_management_software/test_screen2.dart';
import 'package:team_management_software/views/home_screen.dart';
import 'package:team_management_software/views/project_list_screen.dart';
import 'package:team_management_software/views/project_page.dart';
import 'package:team_management_software/views/screens/bottom_navigation.dart';
import 'package:team_management_software/views/screens/my_tasks.dart';
import 'package:team_management_software/views/screens/search2.dart';
import 'package:team_management_software/views/screens/search3.dart';
import 'package:team_management_software/views/sign_in.dart';
import 'package:team_management_software/views/splashscreen.dart';
import 'package:team_management_software/views/task_page.dart';
import 'package:team_management_software/views/test_screen.dart';
import 'package:team_management_software/views/user_sign_up.dart';
import 'change_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    //statusBarColor: Colors.black, // status bar color
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;
  isUserLoggedIn() async {
    userIsLoggedIn = await SharedPreferencesFunctions.getIsUserLoggedIn();
    setState(() {});
  }

  @override
  void initState() {
    isUserLoggedIn();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Data()),
          ],
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              // theme:  ThemeData(
              //   brightness: Brightness.light,
              //   primaryColor:Colors.yellow[800],
              //   splashColor: Colors.yellow[800],
              // ),
              home:
                  //BottomNavigation()
                  // Home()
                  // SplashScreen()
                  Search3()
              //userIsLoggedIn==null||userIsLoggedIn!=true? SplashScreen(): BottomNavigation()
              ));
    });
  }
}
