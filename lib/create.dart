import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';

import 'shell.dart';
import 'version.dart';

FutureOr create(List<String> args) async {
  String project = args[1];

  await shell.run('''
    dart create $project
  ''');

  String directory = absolute(project);
  File pubspec = File('$directory/pubspec.yaml');

  if (pubspec.existsSync()) {
    pubspec.writeAsStringSync('''
name: $project
description: A simple lucifer application.
version: 1.0.0
publish_to: none

environment:
  sdk: '>=2.14.0 <3.0.0'

dependencies:
  lucifer: ^$version

dev_dependencies:
  lints: ^1.0.0
    ''');
  }

  File env = File('$directory/.env');

  if (!env.existsSync()) {
    env.createSync();
  }

  env.writeAsStringSync('''
ENV = development
PORT = 3000
  ''');

  File gitignore = File('$directory/.gitignore');

  if (gitignore.existsSync()) {
    gitignore.writeAsStringSync('''

# Environment variables
.env
    ''', mode: FileMode.append);
  }

  File main = File('$directory/bin/main.dart');

  if (!main.existsSync()) {
    main.createSync();
  }

  main.writeAsStringSync('''
import 'package:lucifer/lucifer.dart';

void main() async {
  final app = App();
  final port = env('PORT') ?? 3000;

  app.use(logger());

  app.get('/', (Req req, Res res) async {
    await res.send('Hello Detective');
  });

  await app.listen(port);
  
  print('Server running at http://\${app.host}:\${app.port}');
  app.checkRoutes();
}
  ''');

  File projectFile = File('$directory/bin/$project.dart');

  if (projectFile.existsSync()) {
    projectFile.deleteSync();
  }

  shell = shell.pushd(project);
  await shell.run('pub get');
  shell = shell.popd();

  print('');
  print(
    'Project $project is ready. Run this command to get started.',
  );
  print('');
  print('    cd $project');
  print('    lucy run');
}
