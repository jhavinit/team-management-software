import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart' ;
import 'dart:io';
class PdfScreen extends StatefulWidget {
  final File? file;
  final String? fileName;
  PdfScreen({this.file,this.fileName});

  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.fileName??"Pdf File"),),
      body: Container(

        child: PDFView(
          filePath: widget.file!.path ,

        ),
      ),
    );
  }
}
