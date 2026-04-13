part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEmployees extends EmployeeEvent {}

class SearchEmployees extends EmployeeEvent {
  final String query;
  SearchEmployees(this.query);
}

class SaveEmployee extends EmployeeEvent {
  final Employee employee;
  final bool isUpdate;
  SaveEmployee(this.employee, this.isUpdate);
}

class DeleteEmployee extends EmployeeEvent {
  final String empCode;
  DeleteEmployee(this.empCode);
}
