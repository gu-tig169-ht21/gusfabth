import 'package:flutter/material.dart';
import 'api.dart';
import 'secondpage.dart';

List<Todo> _input = <Todo>[];
final _filterchoice = <String>["All", "Done", "Undone"]; //filtermenyn
String filterfunction = "All";

Future<List<Todo>>? futureTodoList;

void main() =>
    runApp(const MaterialApp(home: Home(), debugShowCheckedModeBanner: false));

class _ApiGetter {
  Future<List<Todo>> getApi() async {
    _input = await Call.fetchList();
    return _input;
  }
}

//hemsidan

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    futureTodoList = _ApiGetter().getApi();
    super.initState();
  }

  void send(Todo test) async {}

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
        title: const Text("Todo list"),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return (filtrering(filterfunction));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
          future: futureTodoList,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddToDoPage()),
          ).then(get);
        },
      ),
    );
  }

  Future? get(dynamic value) {
    setState(() {
      futureTodoList = _ApiGetter().getApi();
    });
  }
//listskaparen för förstasidan

  Widget listBuilder(List<Todo> input) {
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

// checka av knapp, ta bort knapp, gör rad

  Widget _toDoItem(Todo text) {
    final _ready = text.done;

    _input.contains(text) ? null : _input.add(text);
    return Card(
        child: ListTile(
      title: Text(
        text.title,
        style: TextStyle(
          decoration: _ready ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Icon(
        _ready ? Icons.check_box : Icons.check_box_outline_blank_outlined,
        color: _ready ? Colors.blue : null,
      ),
      onTap: () {
        int index = _input.indexWhere((item) => item.id == text.id);
        if (_ready) {
          Call.updateList(text.title, false, text.id);
          setState(() {
            _input[index].done = false;
          });
        } else {
          Call.updateList(text.title, true, text.id);
          setState(() {
            _input[index].done = true;
          });
        }
      },
      trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            Call.deleteList(text.id);
            setState(() {
              _input.removeWhere((element) => element.id == text.id);
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
          return listBuilder(
              _input.where((todo) => todo.done == true).toList());
        }

      case "Undone":
        {
          return listBuilder(
              _input.where((todo) => todo.done == false).toList());
        }

      default:
        {
          return listBuilder(_input);
        }
    }
  }
}
