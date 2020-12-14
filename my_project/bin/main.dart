import 'package:aqueduct/aqueduct.dart';
import 'package:my_project/my_project.dart';

Future main() async {
  final app = Application<DartServer>()
    ..options.address = '127.0.0.1'
    ..options.port = 8888;

  await app.start();
}
