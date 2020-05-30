import 'package:aqueduct_todo/controllers/todo_controller.dart';

import 'aqueduct_todo.dart';

class AqueductTodoChannel extends ApplicationChannel {
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route("/todos/[:id]").link(() => TodoController());

    return router;
  }
}
