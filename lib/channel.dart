import 'package:aqueduct_todo/controllers/todo_controller.dart';

import 'aqueduct_todo.dart';

class AqueductTodoChannel extends ApplicationChannel {
  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      'dart_todo_user',
      '1234567890',
      'localhost',
      5432,
      'dart_todo',
    );

    context = ManagedContext(dataModel, persistentStore);
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route("/todos/[:id]").link(() => TodoController(context));

    return router;
  }
}
