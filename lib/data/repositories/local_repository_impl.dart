import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/local_database.dart';
import '../models/employee_model.dart';

class LocalRepositoryImpl implements EmployeeRepository {
  final DatabaseHelper dbHelper;
  LocalRepositoryImpl(this.dbHelper);

  @override
  Future<List<Employee>> getEmployees() async =>
      await dbHelper.getAllEmployees();

  @override
  Future<void> addEmployee(Employee emp) async {
    await dbHelper.insertEmployee(EmployeeModel(
        empCode: emp.empCode,
        empName: emp.empName,
        mobile: emp.mobile,
        dob: emp.dob,
        dateOfJoining: emp.dateOfJoining,
        salary: emp.salary,
        address: emp.address,
        remark: emp.remark));
  }

  @override
  Future<void> deleteEmployee(String code) async =>
      await dbHelper.deleteEmployee(code);

  @override
  Future<List<Employee>> searchEmployees(String query) async {
    final all = await dbHelper.getAllEmployees();
    if (query.isEmpty) return all;
    return all
        .where((e) =>
            e.empName.toLowerCase().contains(query.toLowerCase()) ||
            e.empCode.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<void> updateEmployee(Employee emp) async {
    await dbHelper.updateEmployee(EmployeeModel(
        empCode: emp.empCode,
        empName: emp.empName,
        mobile: emp.mobile,
        dob: emp.dob,
        dateOfJoining: emp.dateOfJoining,
        salary: emp.salary,
        address: emp.address,
        remark: emp.remark));
  }
}
