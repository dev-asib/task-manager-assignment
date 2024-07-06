class Urls{
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';

  static const String registration = '$_baseUrl/registration';
  static const String logIn = '$_baseUrl/login';
  static const String createTask = '$_baseUrl/createTask';
  static const String newTasks = '$_baseUrl/listTaskByStatus/New';
  static const String completedTasks = '$_baseUrl/listTaskByStatus/Completed';
  static const String inProgressTasks = '$_baseUrl/listTaskByStatus/Progress';
  static const String cancelledTasks = '$_baseUrl/listTaskByStatus/Cancelled';
  static const String taskStatusCount = '$_baseUrl/taskStatusCount';
  static String deleteTask(String id) => '$_baseUrl/deleteTask/$id';
  static String updateTasksStatus(String taskID, String taskStatus) => '$_baseUrl/updateTaskStatus/$taskID/$taskStatus';
  static const String profileUpdate = '$_baseUrl/profileUpdate';
  static String recoverVerifyEmail(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static String otpVerification(String email, String otp) => '$_baseUrl/RecoverVerifyOTP/$email/$otp';
  static const String recoverResetPass = '$_baseUrl/RecoverResetPass';

}