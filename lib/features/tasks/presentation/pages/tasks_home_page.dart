import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:tasks_app_clean_architecture/features/tasks/presentation/widgets/default_From_Text_Feild.dart';

class TasksHomePage extends StatelessWidget {
  TasksHomePage({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var dataController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksCubit()..createDatabase(),
      child: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state is InsertTaskState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          TasksCubit cubit = TasksCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            // --------------------------------------------------
            // APP BAR
            // --------------------------------------------------
            appBar: AppBar(
              backgroundColor: Colors.blue,
              elevation: 4,
              centerTitle: false,

              title: Text(
                TasksCubit.get(context).titles[TasksCubit.get(
                  context,
                ).currentIndex],
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
            body: ConditionalBuilder(
              condition: TasksCubit.get(context).newtasks.isNotEmpty,
              builder: (context) => TasksCubit.get(
                context,
              ).screens[TasksCubit.get(context).currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),

            // --------------------------------------------------
            // FLOATING ACTION BUTTON
            // --------------------------------------------------
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      data: dataController.text,
                      time: timeController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
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
                                      dataController.text = value
                                          .toString()
                                          .split(' ')[0];
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
                      )
                      .closed
                      .then(((value) {
                        cubit.changeBottomSheetState(
                          isShow: false,
                          icon: Icons.edit,
                        );
                      }));
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },

              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 6,

              shape: const CircleBorder(),

              child: Icon(cubit.fabIcon, size: 30),
            ),

            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

            // --------------------------------------------------
            // BOTTOM NAVIGATION
            // --------------------------------------------------
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: TasksCubit.get(context).currentIndex,

              onTap: (index) {
                TasksCubit.get(context).changeIndex(index);

                // setState(() {
                //   currentIndex = index;
                // });
              },

              type: BottomNavigationBarType.fixed,

              backgroundColor: Colors.white,

              elevation: 8,

              selectedItemColor: const Color(0xFF42A5F5),
              unselectedItemColor: const Color(0xFF9E9E9E),

              selectedFontSize: 14,
              unselectedFontSize: 14,

              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),

              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
              ),

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
        },
      ),
    );
  }
}
