import 'package:aqueduct/managed_auth.dart';
import 'package:aqueduct_todo/aqueduct_todo.dart';
import 'package:string_validator/string_validator.dart';
import 'package:uuid_type/uuid_type.dart';

class User extends ManagedObject<_User>
    implements _User, ManagedAuthResourceOwner<_User> {
  @override
  void willInsert() {
    userId = uuid.v4();
  }

  @Serialize(input: true, output: false)
  String password;

  @override
  ValidationContext validate({Validating forEvent = Validating.insert}) {
    final context = super.validate(forEvent: forEvent);

    if (!isEmail(username)) {
      context.addError(
          'Username is not valid. Enter a valid email address for username');
    }

    // print('Is Length up to 6? ${!isLength(password, 6)}');

    if (password != null && password.length < 6) {
      context.addError('Password should have a minimum of 6 characters');
    }

    return context;
  }
}

class _User extends ResourceOwnerTableDefinition {
  @Column(unique: true)
  String userId;
}
