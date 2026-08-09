import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class TasksHomePage extends StatefulWidget {
  const TasksHomePage({super.key});

  @override
  State<TasksHomePage> createState() => _TasksHomePageState();
}

class _TasksHomePageState extends State<TasksHomePage> {
  int currentIndex = 0;
  late Database database;

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

  void insertToDatabase() {
    database.transaction((txn) {
      txn
          .rawInsert(
            'INSERT INTO tasks(title, data, time, status) VALUES("First Task", "Task Data", "12:00", "new")',
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
          insertToDatabase();
        },

        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 6,

        shape: const CircleBorder(),

        child: const Icon(Icons.add, size: 30),
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
