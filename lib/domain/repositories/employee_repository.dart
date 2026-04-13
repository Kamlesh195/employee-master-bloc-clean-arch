import '../entities/employee.dart';

abstract class EmployeeRepository {
  Future<List<Employee>> getEmployees();
  Future<void> addEmployee(Employee employee);
  Future<void> updateEmployee(Employee employee);
  Future<void> deleteEmployee(String empCode);
  Future<List<Employee>> searchEmployees(String query);
}
