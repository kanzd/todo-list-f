import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List todo = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            const Text("Todo", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0.0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < todo.length) {
                return ListTile(
                  title: Text(todo[index]['todoname']),
                  subtitle: Text("Duration " + todo[index]['duration']),
                  leading: Icon(Icons.event),
                  trailing: IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      (() async {
                        while (int.parse(this.todo[index]['duration']) > 0) {
                          await Future.delayed(Duration(seconds: 1));
                          this.setState(() {
                            this.todo[index]['duration'] =
                                (int.parse(this.todo[index]['duration']) - 1)
                                    .toString();
                          });
                        }
                      })();
                    },
                  ),
                );
              }
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          TextEditingController todoname = TextEditingController();
          TextEditingController time = TextEditingController();
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("cancel")),
                      TextButton(
                          onPressed: () {
                            this.todo.add({
                              "todoname": todoname.text,
                              "duration": time.text,
                            });
                            this.setState(() {});
                            Navigator.pop(context);
                          },
                          child: Text("add"))
                    ],
                    title: Text("Add Todo"),
                    content: Container(
                        height: 150,
                        child: ListView(
                          children: [
                            TextField(
                              controller: todoname,
                              decoration: const InputDecoration(
                                  labelText: "Todo Name",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: time,
                              decoration: const InputDecoration(
                                  labelText: "Duration in sec",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        )));
              });
        },
      ),
    );
  }
}
