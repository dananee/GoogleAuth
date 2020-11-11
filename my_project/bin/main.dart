import 'package:aqueduct/aqueduct.dart';
import 'package:my_project/my_project.dart';

Future main() async {
  final app = Application<DartServer>()
    ..options.address = '127.1.1.1'
    ..options.port = 4050;

  await app.start();
}
