import 'package:aqueduct_todo/aqueduct_todo.dart';
import 'package:uuid_type/uuid_type.dart';

class TodoController extends ResourceController {
  final _todos = [
    {
      'id': 1,
      'title': 'Go to church',
      'description': 'Next sunday is a thanksgiving service',
    },
    {
      'id': 2,
      'title': 'Read my books',
      'description': 'I have exams by next week',
    },
    {
      'id': 3,
      'title': 'Visit Grand mum',
      'description': 'Goind to weija and pass by to visit grand ma',
    },
  ];

  @Operation.get()
  Future<Response> getAllTodos() async {
    return Response.ok({'data': _todos});
  }

  @Operation.get('id')
  Future<Response> getTodoById(@Bind.path('id') int id) async {
    final _todo =
        _todos.firstWhere((todo) => todo['id'] == id, orElse: () => null);

    if (_todo == null) {
      return Response.notFound();
    }

    final _data = {'data': _todo};

    return Response.ok(_data);
  }
}
