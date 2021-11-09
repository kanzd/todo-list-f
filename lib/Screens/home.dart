import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List todo = [];
  SharedPreferences? prefs;
  bool pr = false;
  @override
  void initState() {
    super.initState();
    (() async {
      prefs = await SharedPreferences.getInstance();
      pr = true;
      if (prefs!.containsKey("todo")) {
        List<String>? temptodo = prefs?.getStringList("todo");
        List<String>? tempdurations = prefs?.getStringList("durations");
        int i = 0;
        while (i < temptodo!.length) {
          this.todo.add({
            "todoname": temptodo[i],
            "duration": tempdurations?[i],
            "pause": true,
          });
          i++;
        }
      }
      this.setState(() {});
    })();
  }

  @override
  Widget build(BuildContext context) {
    if (this.pr)
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
                      icon: Icon(this.todo[index]["pause"]
                          ? Icons.play_circle
                          : Icons.pause_circle),
                      onPressed: () {
                        (() async {
                          if (this.todo[index]['pause']) {
                            this.todo[index]['pause'] = false;
                            while (
                                (int.parse(this.todo[index]['duration']) > 0) &&
                                    (!this.todo[index]['pause'])) {
                              await Future.delayed(Duration(seconds: 1));
                              List<String>? lid =
                                  this.prefs?.getStringList("durations");
                              this.todo[index]['duration'] =
                                  (int.parse(this.todo[index]['duration']) - 1)
                                      .toString();
                              lid?[index] = this.todo[index]['duration'];
                              await this
                                  .prefs
                                  ?.setStringList("durations", lid!);
                              this.setState(() {});
                            }
                          } else {
                            this.todo[index]['pause'] = true;
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
                            onPressed: () async {
                              String duration = (int.parse(time.text)*60).toString();
                              this.todo.add({
                                "todoname": todoname.text,
                                "duration":duration,
                                "pause": true,
                              });
                              if (!this.prefs!.containsKey("todo")) {
                                await this
                                    .prefs
                                    ?.setStringList("todo", [todoname.text]);
                                await this
                                    .prefs
                                    ?.setStringList("durations", [duration]);
                              } else {
                                List<String>? lit =
                                    this.prefs?.getStringList("todo");
                                List<String>? lid =
                                    this.prefs?.getStringList("durations");
                                lit?.add(todoname.text);
                                lid?.add(duration);
                                await this.prefs?.setStringList("todo", lit!);
                                await this
                                    .prefs
                                    ?.setStringList("durations", lid!);
                              }
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
                                    labelText: "Duration in Min",
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
    else
      return Scaffold();
  }
}
