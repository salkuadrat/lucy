import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:watcher/watcher.dart';

FutureOr run(List<String> args) async {
  String directory = absolute('');
  String dir = basename(directory);
  String file = '';

  if (args.length > 1) {
    String f = args[1];
    if (File(f).existsSync()) {
      file = f;
    }
  } else {
    List files = [
      'bin/main.dart',
      'bin/$dir.dart',
    ];

    for (var f in files) {
      if (File(f).existsSync()) {
        file = f;
        break;
      }
    }
  }

  if (!file.contains('.dart')) {
    print('Could not find the target file to run.');
    return;
  }

  Process process = await _createProcess(file);
  bool isLoading = false;

  print('Starting...');
  print('');

  DirectoryWatcher(directory).events.listen((event) {
    process.exitCode.then((code) async {
      if (!isLoading) {
        print('Reloading...');
        print('');
        isLoading = true;
        await Future.delayed(Duration(seconds: 1));
        process = await _createProcess(file);
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

Future<Process> _createProcess(String file) async {
  Process process = await Process.start('dart', [file]);
  stderr.addStream(process.stderr);
  stdout.addStream(process.stdout);
  return process;
}
