import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';

import 'shell.dart';

FutureOr build(List<String> args) async {
  String directory = absolute('');
  String dir = basename(directory);
  String file = '';

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

  if (!file.contains('.dart')) {
    print('Could not find the target file to build.');
    return;
  }

  await shell.run('dart compile exe $file');

  String exeFile = file.replaceAll('.dart', '');
  List exeFiles = [exeFile, '$exeFile.exe'];

  for (var f in exeFiles) {
    if (File(f).existsSync()) {
      exeFile = f;
      break;
    }
  }

  File source = File('$directory/$exeFile');
  String filename = exeFile.contains('.exe') ? '$dir.exe' : 'dir';
  String target = '$directory/$filename';

  try {
    source.renameSync(target);
  } on FileSystemException catch (_) {
    source.copySync(target);
    source.deleteSync();
  }

  print('');
  print('Your app is ready at $directory$separator$filename');
  print('');
}
