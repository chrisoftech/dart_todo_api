import 'package:aqueduct/managed_auth.dart';
import 'package:aqueduct_todo/aqueduct_todo.dart';
import 'package:uuid_type/uuid_type.dart';

class User extends ManagedObject<_User>
    implements _User, ManagedAuthResourceOwner<_User> {
  @override
  void willInsert() {
    userId = uuid.v4();
  }

  @Serialize(input: true, output: false)
  String password;
}

class _User extends ResourceOwnerTableDefinition {
  @Column(unique: true)
  String userId;
}
