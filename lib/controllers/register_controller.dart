import 'package:aqueduct_todo/aqueduct_todo.dart';
import 'package:aqueduct_todo/models/user.dart';

class RegisterController extends ResourceController {
  RegisterController(this.authServer, this.context);

  AuthServer authServer;
  ManagedContext context;

  @Operation.post()
  Future<Response> register(@Bind.body() User user) async {
    if (user.username == null || user.password == null) {
      return Response.badRequest(
          body: {"error": "username and password is required."});
    }

    user
      ..salt = AuthUtility.generateRandomSalt()
      ..hashedPassword =
          AuthUtility.generatePasswordHash(user.password, user.salt);

    final _createdUser = await Query(context, values: user).insert();

    return Response.ok({'data': _createdUser.asMap()});
  }
}
