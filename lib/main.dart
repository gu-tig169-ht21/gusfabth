import 'package:flutter/material.dart';
import 'api.dart';
import 'secondpage.dart';

void main() =>
    runApp(const MaterialApp(home: Home(), debugShowCheckedModeBanner: false));

class _ApiGetter {
  Future<List<Todo>> getApi() async {
    _HomeState._input = await Call.fetchList();
    return _HomeState._input;
  }
}

//hemsidan

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<Todo> _input = <Todo>[];
  final _filterchoice = <String>["All", "Done", "Undone"]; //filtermenyn
  String filterfunction = "All";

  Future<List<Todo>>? futureTodoList;

  @override
  void initState() {
    futureTodoList = _ApiGetter().getApi();
    super.initState();
  }

  void send(Todo object) async {}

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
        child: const Icon(Icons.add),
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
        itemCount: _input.length,
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
      onTap: () async {
        if (_ready) {
          await Call.updateList(text.title, false, text.id);
          _input = await Call.fetchList();
          setState(() {});
        } else {
          await Call.updateList(text.title, true, text.id);
          _input = await Call.fetchList();
          setState(() {});
        }
      },
      trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            await Call.deleteList(text.id);
            _input = await Call.fetchList();
            setState(() {});
          }),
    ));
  }

// filreringsfunktionen

  Widget filtrering(String a) {
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
