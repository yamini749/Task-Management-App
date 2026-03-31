import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      home: TaskScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String searchQuery = "";
  String filter = "all";
  bool isLoading = false;

  List<Map<String, dynamic>> tasks = [];

  void showAddTaskDialog({int? index}) {
    String title = index != null ? tasks[index]["title"] : "";
    String description =
        index != null ? tasks[index]["description"] : "";
    String status = index != null ? tasks[index]["status"] : "To-Do";
    DateTime? dueDate =
        index != null ? tasks[index]["dueDate"] : null;
    String? blockedBy =
        index != null ? tasks[index]["blockedBy"] : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(index == null ? "Add Task" : "Edit Task"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      decoration:
                          InputDecoration(labelText: "Title"),
                      controller:
                          TextEditingController(text: title),
                      onChanged: (val) => title = val,
                    ),
                    TextField(
                      decoration:
                          InputDecoration(labelText: "Description"),
                      controller:
                          TextEditingController(text: description),
                      onChanged: (val) => description = val,
                    ),
                    SizedBox(height: 10),

                    // Status
                    DropdownButton<String>(
                      value: status,
                      items: ["To-Do", "In Progress", "Done"]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setStateDialog(() {
                          status = val!;
                        });
                      },
                    ),

                    SizedBox(height: 10),

                    // 🔥 Blocked By
                   DropdownButton<String>(
  hint: Text("Blocked By (optional)"),
  value: blockedBy,

  items: tasks.map<DropdownMenuItem<String>>((task) {
    return DropdownMenuItem<String>(
      value: task["title"] as String,
      child: Text(task["title"]),
    );
  }).toList(),

  onChanged: (val) {
    setStateDialog(() {
      blockedBy = val;
    });
  },
),
                    SizedBox(height: 10),

                    // Date
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          setStateDialog(() {
                            dueDate = picked;
                          });
                        }
                      },
                      child: Text(dueDate == null
                          ? "Select Due Date"
                          : dueDate
                              .toString()
                              .split(" ")[0]),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (title.isEmpty) return;

                    setState(() {
                      isLoading = true;
                    });

                    await Future.delayed(Duration(seconds: 2));

                    setState(() {
                      if (index == null) {
                        tasks.add({
                          "title": title,
                          "description": description,
                          "status": status,
                          "dueDate": dueDate,
                          "blockedBy": blockedBy,
                        });
                      } else {
                        tasks[index] = {
                          "title": title,
                          "description": description,
                          "status": status,
                          "dueDate": dueDate,
                          "blockedBy": blockedBy,
                        };
                      }

                      isLoading = false;
                    });

                    Navigator.pop(context);
                  },
                  child: Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Manager")),

      body: Column(
        children: [
          if (isLoading) LinearProgressIndicator(),

          // Search
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search tasks...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // Filter buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () => setState(() => filter = "all"),
                child: Text("All"),
              ),
              TextButton(
                onPressed: () => setState(() => filter = "done"),
                child: Text("Done"),
              ),
              TextButton(
                onPressed: () => setState(() => filter = "pending"),
                child: Text("Pending"),
              ),
            ],
          ),

          Expanded(
            child: Builder(
              builder: (context) {
                var filteredTasks = tasks.where((task) {
                  bool matchesSearch = task["title"]
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());

                  bool matchesFilter = true;

                  if (filter == "done") {
                    matchesFilter = task["status"] == "Done";
                  } else if (filter == "pending") {
                    matchesFilter = task["status"] != "Done";
                  }

                  return matchesSearch && matchesFilter;
                }).toList();

                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    String? blockedBy = filteredTasks[index]["blockedBy"];

bool isBlocked = false;

if (blockedBy != null) {
  var blockingTask = tasks.firstWhere(
    (task) => task["title"] == blockedBy,
    orElse: () => {},
  );

  if (blockingTask.isNotEmpty &&
      blockingTask["status"] != "Done") {
    isBlocked = true;
  }
}

                    return Opacity(
                      opacity: isBlocked ? 0.5 : 1,
                      child: ListTile(
                        enabled: !isBlocked,
                        title:
                            Text(filteredTasks[index]["title"]),
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(filteredTasks[index]
                                    ["description"] ??
                                ""),
                            Text(
                                "Status: ${filteredTasks[index]["status"]}"),
                            Text(
                                "Due: ${filteredTasks[index]["dueDate"] != null ? filteredTasks[index]["dueDate"].toString().split(" ")[0] : "N/A"}"),
                            if (isBlocked)
                              Text(
                                "Blocked by: ${filteredTasks[index]["blockedBy"]}",
                                style: TextStyle(
                                    color: Colors.red),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit,
                                  color: Colors.blue),
                              onPressed: () {
                                int originalIndex = tasks
                                    .indexOf(filteredTasks[index]);
                                showAddTaskDialog(
                                    index: originalIndex);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  tasks.remove(
                                      filteredTasks[index]);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTaskDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}