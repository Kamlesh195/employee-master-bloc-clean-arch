// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:employee_master/main.dart';
import 'package:employee_master/domain/repositories/employee_repository.dart';
import 'package:employee_master/domain/entities/employee.dart';
import 'package:employee_master/presentaion/bloc/employee_bloc.dart';
import 'package:employee_master/presentaion/bloc/theme_cubit.dart';

class MockEmployeeRepository implements EmployeeRepository {
  @override
  Future<List<Employee>> getEmployees() async => [];
  @override
  Future<void> addEmployee(Employee employee) async {}
  @override
  Future<void> updateEmployee(Employee employee) async {}
  @override
  Future<void> deleteEmployee(String empCode) async {}
  @override
  Future<List<Employee>> searchEmployees(String query) async => [];
}

void main() {
  setUpAll(() {
    final sl = GetIt.instance;
    sl.registerLazySingleton<EmployeeRepository>(() => MockEmployeeRepository());
    sl.registerFactory(() => EmployeeBloc(sl()));
    sl.registerLazySingleton(() => ThemeCubit());
  });

  testWidgets('App renders LoginScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Employee Master Pro'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
  });
}
