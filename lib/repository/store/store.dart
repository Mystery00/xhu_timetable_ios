import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<File> getPoemsStore() async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  return File('$dir/poems');
}
