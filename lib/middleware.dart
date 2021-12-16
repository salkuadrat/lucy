import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';

FutureOr middleware(List<String> args) async {
  List<String> names = args.sublist(1);

  if (names.isEmpty) {
    return;
  }

  String directory = absolute('lib/middleware');
  Directory dir = Directory(directory);

  if (!dir.existsSync()) {
    dir.createSync();
  }

  RegExp alpha = RegExp(r'^[a-zA-Z]+$');

  for (String name in names) {
    if (alpha.hasMatch(name)) {
      _createMiddleware(name, directory);
    }
  }
}

FutureOr _createMiddleware(String name, String directory) async {
  String filename = '$name.dart';
  File file = File('$directory/$filename');

  if (!file.existsSync()) {
    file.createSync();
    file.writeAsStringSync('''
import 'package:lucifer/lucifer.dart';

Callback $name() {
  return (Req req, Res res) async {
    // define your middleware process here
  };
}''');

    print('''
Your $name middleware is ready at ${separator}lib${separator}middleware$separator$filename
    ''');
  }
}
