import 'package:aqueduct/managed_auth.dart';
import 'package:aqueduct_todo/controllers/register_controller.dart';
import 'package:aqueduct_todo/controllers/todo_controller.dart';
import 'package:aqueduct_todo/models/user.dart';

import 'aqueduct_todo.dart';

class AqueductTodoChannel extends ApplicationChannel {
  ManagedContext context;
  AuthServer authServer;

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

    final _delegate = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(_delegate);
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router
        .route("/register")
        .link(() => RegisterController(authServer, context));

    router.route("/login").link(() => AuthController(authServer));

    router
        .route("/todos/[:id]")
        .link(() => Authorizer.bearer(authServer))
        .link(() => TodoController(context));

    return router;
  }
}

class TodoConfiguration extends Configuration {
  TodoConfiguration(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
