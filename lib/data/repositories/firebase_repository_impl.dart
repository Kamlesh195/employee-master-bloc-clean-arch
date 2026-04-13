import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository.dart';
import '../models/employee_model.dart';

class FirebaseRepositoryImpl implements EmployeeRepository {
  final FirebaseFirestore firestore;
  FirebaseRepositoryImpl(this.firestore);

  CollectionReference get _employees => firestore.collection('employees');

  @override
  Future<List<Employee>> getEmployees() async {
    final snapshot = await _employees.get();
    return snapshot.docs
        .map((doc) => EmployeeModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addEmployee(Employee emp) async {
    final model = EmployeeModel(
        empCode: emp.empCode,
        empName: emp.empName,
        mobile: emp.mobile,
        dob: emp.dob,
        dateOfJoining: emp.dateOfJoining,
        salary: emp.salary,
        address: emp.address,
        remark: emp.remark);
    await _employees.doc(emp.empCode).set(model.toMap());
  }

  @override
  Future<void> updateEmployee(Employee emp) async {
    final model = EmployeeModel(
        empCode: emp.empCode,
        empName: emp.empName,
        mobile: emp.mobile,
        dob: emp.dob,
        dateOfJoining: emp.dateOfJoining,
        salary: emp.salary,
        address: emp.address,
        remark: emp.remark);
    await _employees.doc(emp.empCode).update(model.toMap());
  }

  @override
  Future<void> deleteEmployee(String empCode) async =>
      await _employees.doc(empCode).delete();

  @override
  Future<List<Employee>> searchEmployees(String query) async {
    final all = await getEmployees();
    if (query.isEmpty) return all;
    return all
        .where((e) =>
            e.empName.toLowerCase().contains(query.toLowerCase()) ||
            e.empCode.toLowerCase().contains(query.toLowerCase()) ||
            e.dob.contains(query) ||
            e.dateOfJoining.contains(query))
        .toList();
  }
}
