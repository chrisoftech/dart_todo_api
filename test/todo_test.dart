import 'package:aqueduct_todo/models/todo.dart';

import 'harness/app.dart';

void main() {
  final harness = Harness()..install();

  group('GET | ', () {
    group('getAllTodos - ', () {
      test('GET /todos returns 200 OK and an empty data object ', () async {
        final _response = await harness.agent.get('/todos');

        expectResponse(_response, 200, body: {'data': []});
      });

      test('GET /todos returns 200 OK and single data object ', () async {
        final _query = Query<Todo>(harness.application.channel.context)
          ..values.title = 'Working by 6pm'
          ..values.description = 'Completing todo endpoint for test projects';

        await _query.insert();

        final _response = await harness.agent.get('/todos');

        expectResponse(_response, 200, body: {
          'data': everyElement({
            'id': isString,
            'title': isString,
            'description': isString,
            'createdat': isTimestamp,
            'updatedat': isTimestamp,
          })
        });
      });
    });

    group('getTodoById - ', () {
      test('GET /todos/id returns 404 Not found on todo id not existing',
          () async {
        final _response = await harness.agent.get('/todos/1');

        expectResponse(_response, 404, body: null);
      });

      test(
          'GET /todos/ returns 404 Not found on todo id not passed when calling endpoint',
          () async {
        final _response = await harness.agent.get('/todos/');

        expectResponse(_response, 404, body: null);
      });

      test('GET /todos/... returns 200 OK and single data object ', () async {
        final _query = Query<Todo>(harness.application.channel.context)
          ..values.title = 'Working by 6pm'
          ..values.description = 'Completing todo endpoint for test projects';

        final _createdTodo = await _query.insert();

        final _response = await harness.agent.get('/todos/${_createdTodo.id}');

        expectResponse(_response, 200, body: {'data': _createdTodo.asMap()});
      });
    });
  });

  group('POST | ', () {
    test('POST should return 201 Created', () async {
      final _response = await harness.agent.post('/todos', body: {
        'title': 'Working by 6pm',
        'description': 'Completing todo endpoint for test projects',
      });

      expectResponse(_response, 201, body: _response.body.as<Map>());
    });

    test('POST should return 409 Conflict on duplicate entry', () async {
      final _response1 = await harness.agent.post('/todos', body: {
        'title': 'Working by 6pm',
        'description': 'Completing todo endpoint for test projects',
      });

      expectResponse(_response1, 201, body: _response1.body.as<Map>());

      final _response2 = await harness.agent.post('/todos', body: {
        'title': 'Working by 6pm',
        'description': 'Completing todo endpoint for test projects',
      });

      expect(_response2.statusCode, 409);
    });

    test('POST should return 400 Bad request on no request body present',
        () async {
      final _response = await harness.agent.post('/todos', body: null);

      expectResponse(_response, 400, body: null);
    });

    test('POST should return 400 Bad request on empty request body present',
        () async {
      final _response = await harness.agent.post('/todos', body: {});

      expectResponse(_response, 400, body: null);
    });
  });

  group('PUT | ', () {
    test('PUT should return 404 Not found', () async {
      final _response = await harness.agent.put('/todos/1', body: {
        'title': 'Working by 6pm',
        'description': 'Completing todo endpoint for test projects',
      });

      expectResponse(_response, 404, body: null);
    });

    test('PUT should return 200 Success', () async {
      final _query = Query<Todo>(harness.application.channel.context)
        ..values.title = 'Working by 6pm'
        ..values.description = 'Completing todo endpoint for test projects';

      final _createdTodo = await _query.insert();

      final _response =
          await harness.agent.put('/todos/${_createdTodo.id}', body: {
        'title': 'Working by 4pm',
        'description': 'Completing todo endpoint for test projects',
      });

      expectResponse(_response, 200, body: _response.body.as<Map>());
    });

    test('PUT should return 400 Bad request on no request body present',
        () async {
      final _query = Query<Todo>(harness.application.channel.context)
        ..values.title = 'Working by 6pm'
        ..values.description = 'Completing todo endpoint for test projects';

      final _createdTodo = await _query.insert();

      final _response =
          await harness.agent.put('/todos/${_createdTodo.id}', body: null);

      expectResponse(_response, 400, body: null);
    });

    test('PUT should return 400 Bad request on empty request body present',
        () async {
      final _query = Query<Todo>(harness.application.channel.context)
        ..values.title = 'Working by 6pm'
        ..values.description = 'Completing todo endpoint for test projects';

      final _createdTodo = await _query.insert();

      final _response =
          await harness.agent.put('/todos/${_createdTodo.id}', body: {});

      expectResponse(_response, 400, body: null);
    });
  });

  group('DELETE | ', () {
    test('DELETE should return 404 Not found', () async {
      final _response = await harness.agent.delete('/todos/1');

      expectResponse(_response, 404, body: null);
    });

    test('DELETE should return 200 Success', () async {
      final _query = Query<Todo>(harness.application.channel.context)
        ..values.title = 'Working by 6pm'
        ..values.description = 'Completing todo endpoint for test projects';

      final _createdTodo = await _query.insert();

      final _response = await harness.agent.delete('/todos/${_createdTodo.id}');

      expect(_response.statusCode, 200);
    });
  });
}
