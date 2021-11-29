import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:team_management_software/views/components/card_project.dart';

class Search3 extends StatefulWidget {
  const Search3({Key? key}) : super(key: key);

  @override
  _Search3State createState() => _Search3State();
}

class _Search3State extends State<Search3> {
  var searchController = TextEditingController();
  List searchList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 12),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.1,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(fontFamily: 'HelveticaBold'),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Search Courses",
                        hintStyle: TextStyle(fontFamily: 'Helvetica'),
                        prefixIcon: Icon(Icons.search_sharp,
                            color: const Color(0xFF000000)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 3.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(width: 3.0, color: Colors.yellow),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: MediaQuery.of(context).size.width / 4.5,
                    height: MediaQuery.of(context).size.height / 15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: const Color(0xFF000000),
                    ),
                    child: MaterialButton(
                        textColor: Colors.purple,
                        onPressed: () async {
                          var url = Uri.parse(
                              'https://ems-heroku.herokuapp.com/projects/search?name=${searchController.text}');
                          var response = await http.get(url);
                          if (response.statusCode == 200) {
                            //print(response.body);

                            setState(() {
                              var mapResponse = json.decode(response.body);
                              var searchResponse = mapResponse['data'];
                              print(searchResponse);
                              searchList = searchResponse;
                            });
                          }
                        },
                        child: Text(
                          'Search',
                          style: new TextStyle(
                              fontSize: 16.0,
                              color: Colors.yellow,
                              fontFamily: 'HelveticaBold'),
                        )),
                  )
                ],
              ),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: searchList.length,
                itemBuilder: (context, index) {
                  var data = searchList[index];
                  return Container(
                      child: CardForProject(
                    name: data["name"] ?? "name",
                    description: data["description"] ?? "description",
                    projectId: data["_id"],
                    index: index,
                    isArchived: data["isArchived"],
                    isFav: data["isFav"],
                    completionRatio: data["completionRatio"] ?? 1,
                  ));
                })
          ],
        ),
      ),
    );
  }
}
