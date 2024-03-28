import 'dart:io';

Future<File> getPoemsStore() async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  return File('$dir/poems');
}
