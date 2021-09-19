import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class PDFApi {

  static Future<File> loadNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return storeFile(url, bytes);
  }

  static Future<File> storeFile(String url, List<int> bytes) async {
    final fileName = path.basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${fileName}');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}