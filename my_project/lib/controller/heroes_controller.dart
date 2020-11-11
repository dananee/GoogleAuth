import 'package:aqueduct/aqueduct.dart';

class Handler extends ResourceController {
  final List lst = [
    {'id': 1, 'name': 'Python', 'body': 'Awesome Language'},
    {'id': 2, 'name': 'Dart', 'body': 'Awesome Language'},
    {'id': 3, 'name': 'Cs', 'body': 'Awesome Language'},
    {'id': 4, 'name': 'PHP', 'body': 'Awesome Language'},
  ];

  @Operation.get()
  Future<Response> getRoute() async {
    return Response.ok(lst);
  }

  @Operation.get('id')
  Future<Response> getDataById(@Bind.path('id') int id) async {
    // final id = int.parse(request.path.variables['id']);

    final find =
        lst.firstWhere((element) => element['id'] == id, orElse: () => null);
    if (find == null) {
      return Response.notFound();
    }
    return Response.ok(find);
  }
}
