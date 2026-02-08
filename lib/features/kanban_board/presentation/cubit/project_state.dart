part of 'project_cubit.dart';

abstract class ProjectState {}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class ProjectLoaded extends ProjectState {}

class ProjectError extends ProjectState {
  final String? errorMessage;

  ProjectError({this.errorMessage});
}
