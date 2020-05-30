import 'package:aqueduct_todo/aqueduct_todo.dart';
import 'package:uuid_type/uuid_type.dart';

class Todo extends ManagedObject<_Todo> implements _Todo {
  @override
  void willUpdate() {
    updatedat = DateTime.now().toUtc();
  }

  @override
  void willInsert() {
    final _currentTimeUTC = DateTime.now().toUtc();

    id = uuid.v4();
    createdat = _currentTimeUTC;
    updatedat = _currentTimeUTC;
  }
}

class _Todo {
  @Column(primaryKey: true, unique: true)
  String id;

  @Column(unique: true, indexed: true)
  String title;

  String description;
  DateTime createdat;
  DateTime updatedat;
}
