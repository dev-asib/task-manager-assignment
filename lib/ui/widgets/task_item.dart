import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/network_caller/network_caller.dart';
import 'package:task_manager_app/data/utilities/urls.dart';
import 'package:task_manager_app/ui/utility/app_colors.dart';
import 'package:task_manager_app/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.taskModel,
    required this.onUpdateTask,
  });

  final TaskModel taskModel;
  final VoidCallback onUpdateTask;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _deleteTaskInProgress = false;
  bool _updateTaskStatusInProgress = false;

  String dropDownValue = " ";

  List<String> statusList = [
    'New',
    'Completed',
    'Progress',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    dropDownValue = widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        tileColor: Colors.green.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          widget.taskModel.title ?? '',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.themeColor),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              widget.taskModel.description ?? '',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.themeColor),
            ),
            Text(
              "Date: ${widget.taskModel.createdDate}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.deepOrangeAccent),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  backgroundColor: Colors.green,
                  label: Text(
                    widget.taskModel.status ?? 'New',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                ),
                ButtonBar(
                  children: [
                    Visibility(
                      visible: _deleteTaskInProgress == false,
                      replacement: const CenterdProgressIndicator(),
                      child: IconButton(
                        onPressed: () {
                          _deleteTask();
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _updateTaskStatusInProgress == false,
                      replacement: const CenterdProgressIndicator(),
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.edit),
                        iconColor: Colors.green,
                        initialValue: dropDownValue,
                        onSelected: (String selectedValue) {
                          dropDownValue = selectedValue;
                          _updateTaskstatus(dropDownValue);
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return statusList.map((String value) {
                            return PopupMenuItem<String>(
                              value: value,
                              child: Card(
                               shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                color: AppColors.themeColor,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.only(left: 8, right: 8),
                                  title: Text(
                                    value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: dropDownValue == value
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask() async {
    _deleteTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller.getRequest(Urls.deleteTask(widget.taskModel.sId!));

    if (response.isSuccess) {
      if (mounted) {
        snackBarMessage(context, "Task Successfully Deleted");
      }
      widget.onUpdateTask();
    } else {
      if (mounted) {
        snackBarMessage(context, "Get new tasks faild. Try again!");
      }
    }

    _deleteTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _updateTaskstatus(String taskStatus) async {
    _updateTaskStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.updateTasksStatus(
        widget.taskModel.sId!,
        taskStatus,
      ),
    );

    if (response.isSuccess) {
      widget.onUpdateTask();
      if (mounted) {
        snackBarMessage(context, "Task Successfully Updated");
      }
    } else {
      if (mounted) {
        snackBarMessage(context, "Task update faild. Try again!");
      }
    }

    _updateTaskStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
