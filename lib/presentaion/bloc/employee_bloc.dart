import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository.dart';
part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;

  EmployeeBloc(this.repository) : super(EmployeeLoading()) {
    on<LoadEmployees>((event, emit) async {
      emit(EmployeeLoading());
      try {
        emit(EmployeeLoaded(await repository.getEmployees()));
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    });

    on<SearchEmployees>((event, emit) async {
      emit(EmployeeLoaded(await repository.searchEmployees(event.query)));
    });

    on<SaveEmployee>((event, emit) async {
      try {
        if (!event.isUpdate) {
          final employees = await repository.getEmployees();
          final isDuplicate = employees.any((e) =>
              e.empName.toLowerCase() == event.employee.empName.toLowerCase());

          if (isDuplicate) {
            emit(EmployeeError(
                "Employee with name '${event.employee.empName}' already exists!"));
            return;
          }
        }

        if (event.isUpdate) {
          await repository.updateEmployee(event.employee);
          emit(EmployeeOperationSuccess("Employee updated successfully"));
        } else {
          await repository.addEmployee(event.employee);
          emit(EmployeeOperationSuccess("Employee added successfully"));
        }
        add(LoadEmployees());
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    });

    on<DeleteEmployee>((event, emit) async {
      try {
        await repository.deleteEmployee(event.empCode);
        emit(EmployeeOperationSuccess("Employee deleted successfully"));
        add(LoadEmployees());
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    });
  }
}
