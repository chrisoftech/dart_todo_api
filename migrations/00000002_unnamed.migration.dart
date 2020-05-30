import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

class Migration2 extends Migration {
  @override
  Future upgrade() async {}

  @override
  Future downgrade() async {}

  @override
  Future seed() async {
    final _currentTimeUTC = DateTime.now().toUtc();

    final _dataRow = [
      {
        'id': 'f71fecc7-d2b7-4432-8f77-83543a088abd',
        'title': 'Go to church',
        'description': 'Next sunday is a thanksgiving service',
        'createdat': _currentTimeUTC,
        'updatedat': _currentTimeUTC,
      },
      {
        'id': '97e82178-085d-4b73-b880-ab91eff0d034',
        'title': 'Read my books',
        'description': 'I have exams by next week',
        'createdat': _currentTimeUTC,
        'updatedat': _currentTimeUTC,
      },
      {
        'id': '19a25a32-ee76-42f0-9d17-4aaaa2961939',
        'title': 'Visit Grand mum',
        'description': 'Goind to weija and pass by to visit grand ma',
        'createdat': _currentTimeUTC,
        'updatedat': _currentTimeUTC,
      },
    ];

    for (final row in _dataRow) {
      await database.store.execute(
        "INSERT INTO _Todo (id, title, description, createdat, updatedat) VALUES (@id, @title, @description, @createdat, @updatedat)",
        substitutionValues: {
          "id": row['id'],
          "title": row['title'],
          "description": row['description'],
          "createdat": row['createdat'],
          "updatedat": row['updatedat'],
        },
      );
    }
  }
}
