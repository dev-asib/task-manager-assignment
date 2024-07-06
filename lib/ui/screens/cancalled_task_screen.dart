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

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {

  bool _getCancelledTasksInProgress = false;

  List<TaskModel> cancelledTasks = [];

  @override
  void initState() {
    super.initState();
    _getCancelledTasks();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Visibility(
        visible: cancelledTasks.isNotEmpty,
        replacement: const CenteredEmptyLottie(),
        child: RefreshIndicator(
          onRefresh: () async{
            _getCancelledTasks();
          },
          child: Visibility(
            visible: _getCancelledTasksInProgress == false,
            replacement: const CenterdProgressIndicator(),
            child: ListView.builder(
              itemCount: cancelledTasks.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  taskModel: cancelledTasks[index],
                  onUpdateTask: (){
                    _getCancelledTasks();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getCancelledTasks() async {
    _getCancelledTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
    await NetworkCaller.getRequest(Urls.cancelledTasks);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.reponseData);
      cancelledTasks = taskListWrapperModel.taskList ?? [];
    } else {
      if(mounted){
        snackBarMessage(context, "Get completed tasks faild. Try again!");
      }
    }

    _getCancelledTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }

  }


}
