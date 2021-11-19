import 'package:flutter/material.dart';

final List<String> _input = <String>[];
final _TextEdit = TextEditingController();
final _ready = <String>[];
final _filterchoice = <String>["All", "Done", "Undone"]; //filtermenyn
String filterfunction = "All";

void main() {
  runApp(const MaterialApp(
    title: "Att göra",
    home: Home(),
  ));
}

//hemsidan

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
          DropdownButton<String>(
            hint: const Text("Filtrering"),
            dropdownColor: Colors.white,
            items: _filterchoice.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem),
              );
            }).toList(),
            onChanged: (String? newValueSelected) {
              setState(() {
                filterfunction = newValueSelected!;
              });
            },
            value: filterfunction,
          ),
        ],
        title: const Text("Att göra"),
      ),
      body: filtrering(filterfunction),
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

//listskaparen för förstasidan

  Widget listBuilder(List<String> input) {
    return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemBuilder: (BuildContext _context, int n) {
          if (n < input.length) {
            return _toDoItem(input[n]);
          } else {
            return const Divider(
              color: Colors.white,
            );
          }
        });
  }

// checka av knapp, ta bort knapp,

  Widget _toDoItem(String text) {
    final _fardig = _ready.contains(text);

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
          _fardig ? _ready.remove(text) : _ready.add(text);
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

// filreringsfunktionen

  Widget filtrering(String a) {
    List<String> undone = <String>[];
    switch (a) {
      case "All":
        {
          return listBuilder(_input);
        }

      case "Done":
        {
          return listBuilder(_ready);
        }

      case "Undone":
        {
          for (int i = 0; i < _input.length; i++) {
            if (!_ready.contains(_input[i])) {
              undone.add(_input[i]);
            }
          }
          return listBuilder(undone);
        }

      default:
        {
          return listBuilder(_input);
        }
    }
  }
}

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
