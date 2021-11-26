import 'package:http/http.dart' as http;
import 'dart:convert';

String apikey = '893d8cbc-6731-4bd3-abf4-df47ef87199f';
String apiurl = 'https://todoapp-api-pyq5q.ondigitalocean.app';

List<todoList> apiDartList = <todoList>[];

class todoList {
  String id, title;
  bool done;
  todoList(this.id, this.title, this.done);
  factory todoList.fromJson(Map<String, dynamic> json) {
    return todoList(
      json['id'],
      json['title'],
      json['done'],
    );
  }
}

//-----------Sending data to server, POST

Future sendList(String title) async {
  final response = await http.post(
    Uri.parse('$apiurl/todos?key$apikey'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 200) {
    return todoList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

//------------Fetch data from the internet, GET

Future fetchList() async {
  final response = await http.get(Uri.parse('$apiurl/todos?key=$apikey'));

  if (response.statusCode == 200) {
    return todoList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

//------------Updating data over the internet, PUT

Future updateList(String title, bool done, String id) async {
  final response = await http.put(
    Uri.parse('$apiurl/todos/:id?key=$apikey'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
  if (response.statusCode == 200) {
    return todoList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update album.');
  }
}

//---------Delete data on the internet, DELETE

Future deleteList(String id) async {
  final http.Response response = await http.delete(
    Uri.parse('$apiurl/todos/:id?key=$apikey'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  return response;
}
