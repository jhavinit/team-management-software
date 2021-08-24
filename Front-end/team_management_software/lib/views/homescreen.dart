import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(children: <Widget>[
              Text(
                "Welcome",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
              ),
            ]),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage("images/LOGO2.png"))),
            ),
            Column(
              children: <Widget>[
                MaterialButton(
                  minWidth: double.infinity,
                  height: 70,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(50)),
                  onPressed: () {},
                  child: Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 70,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(50)),
                    onPressed: () {},
                    child: Text(
                      "SignUp",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
