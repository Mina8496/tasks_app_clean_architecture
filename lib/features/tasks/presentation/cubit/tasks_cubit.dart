import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/pages/New_Tasks_page.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/pages/archived_tasks_page.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/pages/done_tasks_page.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  static TasksCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [NewTasksPage(), DoneTasksPage(), ArchivedTasksPage()];

  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];

  void createDatabase() {
    openDatabase(
      'tasks.db',
      version: 1,
      onCreate: (database, version) {
        print('Database created');
        database
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
      onOpen: (database) {
        GetDataFromDatabase(database);
        print('Database opened');
      },
    ).then((value) {
      database = value;
      emit(CreateTaskState());
    });
  }

  insertToDatabase({
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
            emit(InsertTaskState());
            print("$value inserted successfully");
            GetDataFromDatabase(database);
          })
          .catchError((error) {
            print("Error when inserting new record ${error.toString()}");
          });
      return Future.value();
    });
  }

  void GetDataFromDatabase(database) {
    newtasks = [];
    donetasks = [];
    archivedtasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newtasks.add(element);
        } else if (element['status'] == 'done') {
          donetasks.add(element);
        } else if (element['status'] == 'archived') {
          archivedtasks.add(element);
        }
      });
      emit(GetTasksState());
    });
  }

  void updateData({required String status, required int id}) async {
    database
        .rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', ['$status', id])
        .then((value) {
          GetDataFromDatabase(database);
          emit(UpdateTasksState());
        });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }
}
