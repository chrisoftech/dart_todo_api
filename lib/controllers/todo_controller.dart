import 'package:aqueduct_todo/aqueduct_todo.dart';
import 'package:aqueduct_todo/models/todo.dart';

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

  @Operation.post()
  Future<Response> createTodo(@Bind.body() Todo todo) async {
    final _query = Query<Todo>(context)
      ..values.title = todo.title
      ..values.description = todo.description;

    final _createdTodo = await _query.insert();

    return Response.created('/todo/${_createdTodo.id}',
        body: {'data': _createdTodo.asMap()});
  }

  @Operation.put('id')
  Future<Response> updateTodo(
      @Bind.path('id') String id, @Bind.body() Todo todo) async {
    if (todo.asMap().isEmpty) {
      return Response.badRequest();
    }

    final _query = Query<Todo>(context)
      ..where((todo) => todo.id).equalTo(id)
      ..values = todo;

    final _updatedTodo = await _query.updateOne();

    if (_updatedTodo == null) {
      return Response.notFound();
    }

    return Response.ok({'data': _updatedTodo.asMap()});
  }

  @Operation.delete('id')
  Future<Response> deleteTodo(@Bind.path('id') String id) async {
    final _query = Query<Todo>(context)..where((todo) => todo.id).equalTo(id);

    final _deletedTodoCount = await _query.delete();

    if (_deletedTodoCount == 0) {
      return Response.notFound();
    }

    return Response.ok('$_deletedTodoCount todo(s) deleted');
  }
}
