import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/network_caller/network_caller.dart';
import 'package:task_manager_app/data/utilities/urls.dart';
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
    'InProgress',
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
        title: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            widget.taskModel.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                widget.taskModel.description ?? ''),
            Text(
              "Date: ${widget.taskModel.createdDate}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(widget.taskModel.status ?? 'New'),
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
                          color: Colors.red,
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
                          _updateTaskstatus(
                            dropDownValue
                          );
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return statusList.map((String value) {
                            return PopupMenuItem<String>(
                              value: value,
                              child: ListTile(
                                title: Text(value),
                                trailing: dropDownValue == value
                                    ? const Icon(Icons.done)
                                    : null,
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
