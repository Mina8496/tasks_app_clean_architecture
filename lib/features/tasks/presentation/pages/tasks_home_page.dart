import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/widgets/default_From_Text_Feild.dart';

class TasksHomePage extends StatefulWidget {
  const TasksHomePage({super.key});

  @override
  State<TasksHomePage> createState() => _TasksHomePageState();
}

class _TasksHomePageState extends State<TasksHomePage> {
  int currentIndex = 0;
  late Database database;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var dataController = TextEditingController();
  var timeController = TextEditingController();

  void createDatabase() async {
    database = await openDatabase(
      'tasks.db',
      version: 1,
      onCreate: (db, version) {
        print('Database created');
        db
            .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, data TEXT, time TEXT, status TEXT)',
            )
            .then((value) {
              print("create table");
            })
            .catchError((error) {
              print("Error when creating table ${error.toString()}");
            });
      },
      onOpen: (db) {
        print('Database opened');
      },
    );
  }

  Future insertToDatabase({
    required String title,
    required String data,
    required String time,
  }) async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
            'INSERT INTO tasks(title, data, time, status) VALUES("$title", "$data", "$time", "new")',
          )
          .then((value) {
            print("$value inserted successfully");
          })
          .catchError((error) {
            print("Error when inserting new record ${error.toString()}");
          });
      return Future.value();
    });
  }

  @override
  initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFFAFCFA),

      // --------------------------------------------------
      // APP BAR
      // --------------------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 4,
        centerTitle: false,

        title: const Text(
          'New Tasks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),

      // --------------------------------------------------
      // BODY
      // --------------------------------------------------
      body: const Center(
        child: Text(
          'New Tasks',
          style: TextStyle(
            color: Color(0xFF202124),
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // --------------------------------------------------
      // FLOATING ACTION BUTTON
      // --------------------------------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertToDatabase(
                    title: titleController.text,
                    data: dataController.text,
                    time: timeController.text,
                  )
                  .then((value) {
                    Navigator.pop(context);
                    isBottomSheetShown = false;
                    setState(() {
                      fabIcon = Icons.edit;
                    });
                  })
                  .catchError((error) {
                    print(
                      "Error when inserting new record ${error.toString()}",
                    );
                  });
            }
          } else {
            scaffoldKey.currentState?.showBottomSheet(
              (context) => Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DefaultFromTextFeild(
                        labelText: 'Task title',
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a task name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      DefaultFromTextFeild(
                        labelText: 'Task Data',
                        controller: dataController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter task data';
                          }
                          return null;
                        },
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          ).then((value) {
                            print(DateFormat.yMMMd().format(value!));
                            dataController.text = value.toString().split(
                              ' ',
                            )[0];
                          });
                        },
                      ),

                      SizedBox(height: 10),
                      DefaultFromTextFeild(
                        labelText: 'Task time',
                        controller: timeController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter task time';
                          }
                          return null;
                        },
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            timeController.text = value!
                                .format(context)
                                .toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },

        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 6,

        shape: const CircleBorder(),

        child: Icon(fabIcon, size: 30),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // --------------------------------------------------
      // BOTTOM NAVIGATION
      // --------------------------------------------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        backgroundColor: Colors.white,

        elevation: 8,

        selectedItemColor: const Color(0xFF42A5F5),
        unselectedItemColor: const Color(0xFF9E9E9E),

        selectedFontSize: 14,
        unselectedFontSize: 14,

        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),

        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),

        items: const [
          // Tasks
          BottomNavigationBarItem(
            icon: Icon(Icons.format_align_left, size: 27),
            label: 'Tasks',
          ),

          // Done
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline, size: 27),
            label: 'Done',
          ),

          // Archived
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined, size: 27),
            label: 'Archived',
          ),
        ],
      ),
    );
  }
}
