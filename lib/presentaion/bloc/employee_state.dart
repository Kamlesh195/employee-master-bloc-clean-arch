part of 'employee_bloc.dart';

abstract class EmployeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;
  EmployeeLoaded(this.employees);
  @override
  List<Object?> get props => [employees];
}

class EmployeeError extends EmployeeState {
  final String msg;
  EmployeeError(this.msg);
  @override
  List<Object?> get props => [msg];
}

class EmployeeOperationSuccess extends EmployeeState {
  final String message;
  EmployeeOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}
