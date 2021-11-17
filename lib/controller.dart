import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';

import 'extensions.dart';

FutureOr controller(List<String> args) async {
  List<String> names = args.sublist(1);

  if (names.isEmpty) {
    return;
  }

  String directory = absolute('lib/controller');
  Directory dir = Directory(directory);

  if (!dir.existsSync()) {
    dir.createSync();
  }

  RegExp alpha = RegExp(r'^[a-zA-Z]+$');

  for (String name in names) {
    if (alpha.hasMatch(name)) {
      _createController(name, directory);
    }
  }
}

FutureOr _createController(String name, String directory) async {
  String filename = '${name.toLowerCase()}_controller.dart';
  String className = '${name.toLowerCase().inCaps}Controller';

  File file = File('$directory/$filename');

  if (!file.existsSync()) {
    file.createSync();
    file.writeAsStringSync('''
import 'dart:async';

import 'package:lucifer/lucifer.dart';

class $className extends Controller {
  $className(App app) : super(app);

  @override
  FutureOr index(Req req, Res res) async {

  }

  @override
  FutureOr view(Req req, Res res) async {

  }

  @override
  FutureOr create(Req req, Res res) async {

  }

  @override
  FutureOr edit(Req req, Res res) async {
  
  }

  @override
  FutureOr delete(Req req, Res res) async {
  
  }

  @override
  FutureOr deleteAll(Req req, Res res) async {
  
  }
}
    ''');

    print(
        '$className is ready at ${separator}lib${separator}controller$separator$filename');
  }
}
