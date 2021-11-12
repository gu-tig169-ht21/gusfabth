import 'package:flutter/material.dart';

final List<String> _input = <String>[""];
final _TextEdit = TextEditingController();
final _klar = <String>[];

void main() {
  runApp(const MaterialApp(
    title: "Att göra",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.more_vert),
              tooltip: "Lägg till och ta bort",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddToDoPage()),
                );
              })
        ],
        title: const Text("Att göra"),
      ),
      body: listBuilder(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddToDoPage()),
          );
        },
      ),
    );
  }

  Widget listBuilder() {
    return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemBuilder: (BuildContext _context, int n) {
          if (n < _input.length) {
            return _toDoItem(_input[n]);
          } else {
            return const Divider(
              color: Colors.white,
            );
          }
        });
  }

  Widget _toDoItem(String text) {
    final _fardig = _klar.contains(text);

    _input.contains(text) ? null : _input.add(text);
    return Card(
        child: ListTile(
      title: Text(
        text,
        style: TextStyle(
          decoration: _fardig ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Icon(
        _fardig ? Icons.check_box : Icons.check_box_outline_blank_outlined,
        color: _fardig ? Colors.blue : null,
      ),
      onTap: () {
        setState(() {
          _fardig ? _klar.remove(text) : _klar.add(text);
        });
      },
      trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            setState(() {
              _input.remove(text);
            });
          }),
    ));
  }
}

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
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            TextField(controller: _TextEdit),
            const Divider(height: 18),
            OutlinedButton(
                onPressed: () {
                  setState(() {
                    _input.add(_TextEdit.text);
                    _TextEdit.clear();
                  });
                },
                child: const Text("Add")),
          ],
        )));
  }
}
