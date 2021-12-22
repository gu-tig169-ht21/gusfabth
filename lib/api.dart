import 'package:http/http.dart' as http;
import 'dart:convert';

class Todo {
  String id, title;
  bool done;
  Todo({this.id = "", required this.title, this.done = false});
  factory Todo.fromJson(Map<dynamic, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      done: json['done'] as bool,
    );
  }
}

class Call {
  List<Todo> apiDartList = <Todo>[];

  static String apikey = '893d8cbc-6731-4bd3-abf4-df47ef87199f';
  static String apiurl = 'https://todoapp-api-pyq5q.ondigitalocean.app';

  //-----------Sending data to server, POST

  static Future<List<Todo>> sendList(Todo object) async {
    http.Response response = await http.post(
      Uri.parse('$apiurl/todos?key=$apikey'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': object.title,
        'done': object.done,
      }),
    );

    List<dynamic> parsedList = jsonDecode(response.body);
    List<Todo> apiDartList =
        List<Todo>.from(parsedList.map((i) => Todo.fromJson(i)));
    return apiDartList;
  }

//------------Fetch data from the internet, GET

  static Future<List<Todo>> fetchList() async {
    http.Response response =
        await http.get(Uri.parse('$apiurl/todos?key=$apikey'));

    List<dynamic> parsedList = jsonDecode(response.body);
    List<Todo> apiDartList =
        List<Todo>.from(parsedList.map((i) => Todo.fromJson(i)));
    return apiDartList;
  }

//------------Updating data over the internet, PUT

  static Future<Todo> updateList(String title, bool done, String id) async {
    http.Response response = await http.put(
      Uri.parse('$apiurl/todos/$id?key=$apikey'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'done': done,
      }),
    );

    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body)[0]);
    } else {
      throw Exception('Failed to update album.');
    }
  }

//---------Delete data on the internet, DELETE

  static Future deleteList(String id) async {
    final http.Response response = await http.delete(
      Uri.parse('$apiurl/todos/$id?key=$apikey'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }
}
