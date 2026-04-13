import '../../domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    required super.empCode,
    required super.empName,
    required super.mobile,
    required super.dob,
    required super.dateOfJoining,
    required super.salary,
    required super.address,
    required super.remark,
  });

  Map<String, dynamic> toMap() => {
        'empCode': empCode,
        'empName': empName,
        'mobile': mobile,
        'dob': dob,
        'dateOfJoining': dateOfJoining,
        'salary': salary,
        'address': address,
        'remark': remark,
      };

  factory EmployeeModel.fromMap(Map<String, dynamic> map) => EmployeeModel(
        empCode: map['empCode'] ?? '',
        empName: map['empName'] ?? '',
        mobile: map['mobile'] ?? '',
        dob: map['dob'] ?? '',
        dateOfJoining: map['dateOfJoining'] ?? '',
        salary: (map['salary'] ?? 0).toDouble(),
        address: map['address'] ?? '',
        remark: map['remark'] ?? '',
      );
}
