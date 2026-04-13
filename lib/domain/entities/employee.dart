import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String empCode, empName, mobile, dob, dateOfJoining, address, remark;
  final double salary;

  const Employee({
    required this.empCode,
    required this.empName,
    required this.mobile,
    required this.dob,
    required this.dateOfJoining,
    required this.salary,
    required this.address,
    required this.remark,
  });

  @override
  List<Object?> get props =>
      [empCode, empName, mobile, dob, dateOfJoining, salary, address, remark];
}
