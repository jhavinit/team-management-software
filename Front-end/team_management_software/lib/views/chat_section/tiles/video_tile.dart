import 'package:flutter/material.dart';

class VideoTile extends StatelessWidget {
  final  String? side;
  final String? name;
  VideoTile({this.side,this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: side == "left" ? Colors.grey : Colors.blueGrey,
      ),
      //height: 70,

      child: Row(
        children: [
          const Expanded(
              child: Icon(
                Icons.ondemand_video,
                color: Colors.black,
                size: 60,
              )),
          Expanded(
            flex: 2,
            child: Text(name!,
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          )
        ],
      ),
    );
  }
}
