class AppUrl {
  static const postCreateProject = '/rest/v2/projects';
  static const getTasks = '/rest/v2/tasks';
  static const postCreateTask = '/rest/v2/tasks';
  static String Function(String) get postUpdateTask =>
      (id) => '/rest/v2/tasks/$id';

  static const postAddComment = '/rest/v2/comments';
}
