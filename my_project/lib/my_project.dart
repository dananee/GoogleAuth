import 'package:my_project/controller/heroes_controller.dart';
import 'package:my_project/my_project.dart';
import 'package:aqueduct/aqueduct.dart';

class DartServer extends ApplicationChannel {
  @override
  Controller get entryPoint {
    final router = Router();

    router.route('/heroes/[:id]').link(() => Handler());
    return router;
  }
}
