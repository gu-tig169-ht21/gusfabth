// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'api.dart';

final _textEdit = TextEditingController();

//andra sidan

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({Key? key}) : super(key: key);

  @override
  _AddToDoPageState createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Utöka To do list"),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(20)),
            TextField(
              controller: _textEdit,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: ""),
            ),
            const Divider(height: 18),
            OutlinedButton(
                child: const Text("Lägg till"),
                onPressed: () {
                  Todo object = Todo(title: _textEdit.text);
                  Call.sendList(object);
                  _textEdit.clear();
                }),
          ],
        )));
  }
}
