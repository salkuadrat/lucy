import 'package:lucy/lucy.dart';

main(List<String> args) async {
  print('');
  print('Lucifer $version');
  print('');

  if (args.isNotEmpty) {
    if (args.first == 'run') {
      return await run(args);
    } else if (args.first == 'create' && args.length > 1) {
      return await create(args);
    } else if (args.first == 'c' && args.length > 1) {
      return await controller(args);
    } else if (args.first == 'r' && args.length > 1) {
      return await repository(args);
    } else if (args.first == 'db') {
      return await db(args);
    }
  }

  _error();
}

void _error() {
  print('Please use a correct command, such as:');
  print('');
  print('    lucy run');
  print('    lucy bin/main.dart');
  print('');
  print('    lucy create <project-name>');
  print('');
  print('    lucy c <controller-name>');
  print('');
  print('    lucy r <repository-name>');
  print('');
}
