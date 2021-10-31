import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:process_run/shell.dart';
import 'package:watcher/watcher.dart';

String version = '1.0.1';

main(List<String> args) async {
  print('');
  print('Lucifer $version');
  print('');

  if (args.isNotEmpty) {
    if (args.first == 'run') {
      return await _hotrun(args);
    } else if (args.first.contains('.dart')) {
      return await _hotrun(args);
    } else if (args.first == 'create' && args.length > 1) {
      return await _create(args);
    } else if (args.first == 'c' && args.length > 1) {
      return await _controller(args);
    } else if (args.first == 'r' && args.length > 1) {
      return await _repository(args);
    } else if (args.first == 'db') {
      return await _db(args);
    }
  }

  _error();
}

void _error() {
  print('Please use a correct lucifer command, such as:');
  print('');
  print('  lucifer run');
  print('  lucifer bin/main.dart');
  print('');
  print('  lucifer create <project-name>');
  print('');
  print('  lucifer c <controller-name>');
  print('');
  print('  lucifer r <repository-name>');
  print('');
}

Future<void> _hotrun(List<String> args) async {
  String directory = absolute('');
  String dirname = basename(directory);
  String file = '';

  String argument = args[0];

  if (argument == 'run') {
    List files = [
      'bin/$dirname.dart',
      'bin/main.dart',
    ];

    for (var f in files) {
      if (File(f).existsSync()) {
        file = f;
        break;
      }
    }
  } else {
    file = argument;
  }

  if (!file.contains('.dart')) {
    print('Could not find target file to run.');
    return;
  }

  Process process = await _run(file);
  bool isLoading = false;

  print('Starting...');
  print('');

  DirectoryWatcher(directory).events.listen((event) {
    process.exitCode.then((code) async {
      if (!isLoading) {
        print('Reloading...');
        print('');
        isLoading = true;
        process = await _run(file);
        isLoading = false;
      }
    });
    process.kill();
  });

  ProcessSignal.sigint.watch().listen((event) {
    process.exitCode.then((_) => exit(0));
    process.kill();
  });
}

Future<Process> _run(String file) async {
  Process process = await Process.start('dart', [file]);
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
  return process;
}

Future<void> _create(List<String> args) async {
  Shell shell = Shell();
  String project = args[1];

  await shell.run('''
    dart create $project
    cd $project && pub get
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

  print('');
  print(
    'Project $project is ready in $project. Run this command to get started.',
  );
  print('');
  print('  cd $project');
  print('  lucifer run');
}

FutureOr _controller(List<String> args) async {
  List<String> names = args.sublist(1);

  if (names.isEmpty) {
    return;
  }

  String directory = absolute('bin/controller');
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

    print('Class $className is added to /bin/controller/$filename');
  }
}

FutureOr _repository(List<String> args) async {
  List<String> names = args.sublist(1);

  if (names.isEmpty) {
    return;
  }

  String directory = absolute('bin/repository');
  Directory dir = Directory(directory);

  if (!dir.existsSync()) {
    dir.createSync();
  }

  RegExp alpha = RegExp(r'^[a-zA-Z]+$');

  for (String name in names) {
    if (alpha.hasMatch(name)) {
      _createRepository(name, directory);
    }
  }
}

FutureOr _createRepository(String name, String directory) async {
  String filename = '${name.toLowerCase()}_repository.dart';
  String className = '${name.toLowerCase().inCaps}Repository';

  File file = File('$directory/$filename');

  if (!file.existsSync()) {
    file.createSync();
    file.writeAsStringSync('''
import 'package:lucifer/lucifer.dart';

class $className extends Repository {
  $className(App app) : super(app);
}
    ''');

    print('Class $className is added to /bin/repository/$filename');
  }
}

Future<void> _db(List<String> args) async {
  //
  // Create cli commands for database:
  //
  // lucifer db init
  // lucifer db create
  // lucifer db model --name User --attributes
  // lucifer db migrate
  // lucifer db seed --name users
  // lucifer db seeds
  //
  print('Command lucifer db is under development...');
}

extension CapExtension on String {
  String get inCaps =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
