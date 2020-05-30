import 'package:aqueduct_todo/aqueduct_todo.dart';
import 'package:aqueduct_todo/models/todo.dart';
import 'package:uuid_type/uuid_type.dart';
import 'package:meta/meta.dart';

class TodoController extends ResourceController {
  TodoController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllTodos({@Bind.query('title') String title}) async {
    final _query = Query<Todo>(context);

    if (title != null) {
      _query.where((todo) => todo.title).contains(title, caseSensitive: false);
    }

    final _fetchedTodos = await _query.fetch();

    final _todoMap = _fetchedTodos?.map((todo) => todo.asMap())?.toList();

    return Response.ok({'data': _todoMap});
  }

  @Operation.get('id')
  Future<Response> getTodoById(@Bind.path('id') String id) async {
    final _query = Query<Todo>(context)..where((todo) => todo.id).equalTo(id);

    final _todo = await _query.fetchOne();

    if (_todo == null) {
      return Response.notFound();
    }

    return Response.ok({'data': _todo?.asMap()});
  }
}
