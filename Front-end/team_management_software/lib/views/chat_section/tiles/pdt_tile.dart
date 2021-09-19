import 'package:flutter/material.dart';
class PdfTile extends StatelessWidget {
  final String? name,side,url;

  const PdfTile({Key? key, this.name, this.side, this.url});


  @override
  Widget build(BuildContext context) {
    return Container(
      //   width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: side == "left" ? Colors.grey : Colors.blueGrey,
        ),
        //height: 70,

        child: Row(
          children: [
            const Expanded(
                child: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.black,
                  size: 50,
                )),
            Expanded(
              flex: 2,
              child: Text(name!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            )
          ],
        )
    );
  }
}
