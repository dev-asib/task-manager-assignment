import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_count_by_status_model.dart';
import 'package:task_manager_app/data/model/task_count_by_status_wrapper_model.dart';
import 'package:task_manager_app/data/model/task_list_wrapper_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/network_caller/network_caller.dart';
import 'package:task_manager_app/data/utilities/urls.dart';
import 'package:task_manager_app/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_app/ui/utility/app_colors.dart';
import 'package:task_manager_app/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/centered_empty_lottie.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_app/ui/widgets/task_item.dart';
import 'package:task_manager_app/ui/widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTasksInProgress = false;

  List<TaskModel> newTasks = [];

  bool _getTaskCountByStatusInProgress = false;

  List<TaskCountByStatusModel> taskCountStatusList = [];

  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus();
    _getNewTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: Column(
          children: [
            _buildSummarySection(),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _getNewTasks();
                  _getTaskCountByStatus();
                },
                child: Visibility(
                  visible: _getNewTasksInProgress == false,
                  replacement: const CenterdProgressIndicator(),
                  child: Visibility(
                    visible: newTasks.isNotEmpty,
                    replacement: const SingleChildScrollView(
                      child: CenteredEmptyLottie(),
                    ),
                    child: ListView.builder(
                      itemCount: newTasks.length,
                      itemBuilder: (context, index) {
                        return TaskItem(
                          taskModel: newTasks[index],
                          onUpdateTask: () {
                            _getNewTasks();
                            _getTaskCountByStatus();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.themeColor,
        foregroundColor: AppColors.white,
        onPressed: _onTapAddButton,
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }

  void _onTapAddButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Visibility(
      visible: _getTaskCountByStatusInProgress == false,
      replacement: const CenterdProgressIndicator(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: taskCountStatusList.map((e) {
            return TaskSummaryCard(
              count: e.sum.toString(),
              title: (e.sId ?? 'Unknown').toUpperCase(),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _getNewTasks() async {
    _getNewTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller.getRequest(Urls.newTasks);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.reponseData);
      newTasks = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        snackBarMessage(
          context,
          "Get new tasks failed. Try again!",
          true,
        );
      }
    }

    _getNewTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getTaskCountByStatus() async {
    _getTaskCountByStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller.getRequest(Urls.taskStatusCount);

    if (response.isSuccess) {
      TaskCountByStatusWrapperModel taskCountByStatusWrapperModel =
          TaskCountByStatusWrapperModel.fromJson(response.reponseData);
      taskCountStatusList =
          taskCountByStatusWrapperModel.taskCountByStatusList ?? [];
    } else {
      if (mounted) {
        snackBarMessage(
          context,
          "Get tasks count failed. Try again!",
          true,
        );
      }
    }

    _getTaskCountByStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
