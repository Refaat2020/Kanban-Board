abstract class TaskManagementDataSource {
  Future<Map<String, dynamic>> createTask(Map<String, dynamic> taskContent);
  Future<Map<String, dynamic>> updateTask(
      Map<String, dynamic> updatedTaskContent, String taskId);
}
