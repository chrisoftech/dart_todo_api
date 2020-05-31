import 'package:aqueduct_todo/controllers/todo_controller.dart';

import 'aqueduct_todo.dart';

class AqueductTodoChannel extends ApplicationChannel {
  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();

    final _config = TodoConfiguration(options.configurationFilePath);
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      _config.database.username,
      _config.database.password,
      _config.database.host,
      _config.database.port,
      _config.database.databaseName,
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

class TodoConfiguration extends Configuration {
  TodoConfiguration(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
