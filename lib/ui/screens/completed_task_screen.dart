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

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {

  bool _getCompletedTasksInProgress = false;

  List<TaskModel> completedTasks = [];

  @override
  void initState() {
    super.initState();
    _getCompletedTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Visibility(
        visible: completedTasks.isNotEmpty,
        replacement: const CenteredEmptyLottie(),
        child: RefreshIndicator(
          onRefresh: () async{
            _getCompletedTasks();
          },
          child: Visibility(
            visible: _getCompletedTasksInProgress == false,
            replacement: const CenterdProgressIndicator(),
            child: ListView.builder(
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
               return TaskItem(
                 taskModel: completedTasks[index],
                 onUpdateTask: (){
                   _getCompletedTasks();
                 },
               );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getCompletedTasks() async {
    _getCompletedTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
    await NetworkCaller.getRequest(Urls.completedTasks);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.reponseData);
      completedTasks = taskListWrapperModel.taskList ?? [];
    } else {
      if(mounted){
        snackBarMessage(context, "Get completed tasks faild. Try again!");
      }
    }

    _getCompletedTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }

  }


}
