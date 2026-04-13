import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/local_database.dart';
import '../models/employee_model.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final DatabaseHelper dbHelper;

  EmployeeRepositoryImpl(this.dbHelper);

  @override
  Future<List<Employee>> getEmployees() async {
    return await dbHelper.getAllEmployees();
  }

  @override
  Future<void> addEmployee(Employee employee) async {
    final model = EmployeeModel(
      empCode: employee.empCode,
      empName: employee.empName,
      mobile: employee.mobile,
      dob: employee.dob,
      dateOfJoining: employee.dateOfJoining,
      salary: employee.salary,
      address: employee.address,
      remark: employee.remark,
    );
    await dbHelper.insertEmployee(model);
  }

  @override
  Future<void> deleteEmployee(String empCode) async {
    await dbHelper.deleteEmployee(empCode);
  }

  @override
  Future<List<Employee>> searchEmployees(String query) async {
    final all = await dbHelper.getAllEmployees();
    return all
        .where(
          (e) =>
              e.empName.toLowerCase().contains(query.toLowerCase()) ||
              e.empCode.toLowerCase().contains(query.toLowerCase()) ||
              e.dob.contains(query) ||
              e.dateOfJoining.contains(query),
        )
        .toList();
  }

  @override
  Future<void> updateEmployee(Employee employee) async {
    final model = EmployeeModel(
      empCode: employee.empCode,
      empName: employee.empName,
      mobile: employee.mobile,
      dob: employee.dob,
      dateOfJoining: employee.dateOfJoining,
      salary: employee.salary,
      address: employee.address,
      remark: employee.remark,
    );
    await dbHelper.updateEmployee(model);
  }
}
