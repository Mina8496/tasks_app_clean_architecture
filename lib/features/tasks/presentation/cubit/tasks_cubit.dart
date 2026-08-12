import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/cubit/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  static TasksCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

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
        getDataFromDatabase(database);
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
            getDataFromDatabase(database);
          })
          .catchError((error) {
            print("Error when inserting new record ${error.toString()}");
          });
      return Future.value();
    });
  }

  void getDataFromDatabase(Database database) {
    newtasks = [];
    donetasks = [];
    archivedtasks = [];
    emit(GetLoadingTasksState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      for (final element in value) {
        if (element['status'] == 'new') {
          newtasks.add(element);
        } else if (element['status'] == 'done') {
          donetasks.add(element);
        } else if (element['status'] == 'archived') {
          archivedtasks.add(element);
        }
      }
      emit(GetTasksState());
    });
  }

  void updateData({required String status, required int id}) async {
    database
        .rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', ['$status', id])
        .then((value) {
          getDataFromDatabase(database);
          emit(UpdateTasksState());
        });
  }

  void deleteTask({required int id}) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(DeleteTasksState());
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
