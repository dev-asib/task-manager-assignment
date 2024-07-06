import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_list_wrapper_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/network_caller/network_caller.dart';
import 'package:task_manager_app/data/utilities/urls.dart';
import 'package:task_manager_app/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/centered_empty_lottie.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_app/ui/widgets/task_item.dart';

class InprogressTaskScreen extends StatefulWidget {
  const InprogressTaskScreen({super.key});

  @override
  State<InprogressTaskScreen> createState() => _InprogressTaskScreenState();
}

class _InprogressTaskScreenState extends State<InprogressTaskScreen> {

  bool _getInProgressTasksInProgress = false;

  List<TaskModel> inProgressTasks = [];

  @override
  void initState() {
    super.initState();
    _getInprogressTasks();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Visibility(
        visible: inProgressTasks.isNotEmpty,
        replacement: const CenteredEmptyLottie(),
        child: RefreshIndicator(
          onRefresh: () async{
            _getInprogressTasks();
          },
          child: Visibility(
            visible: _getInProgressTasksInProgress == false,
            replacement: const CenterdProgressIndicator(),
            child: ListView.builder(
              itemCount: inProgressTasks.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  taskModel: inProgressTasks[index],
                  onUpdateTask: (){
                    _getInprogressTasks();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getInprogressTasks() async {
    _getInProgressTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
    await NetworkCaller.getRequest(Urls.inProgressTasks);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.reponseData);
      inProgressTasks = taskListWrapperModel.taskList ?? [];
    } else {
      if(mounted){
        snackBarMessage(context, "Get completed tasks faild. Try again!");
      }
    }

    _getInProgressTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }

  }


}
