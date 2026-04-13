import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_master/domain/repositories/employee_repository.dart';
import 'package:employee_master/data/repositories/firebase_repository_impl.dart';
import 'package:employee_master/data/repositories/local_repository_impl.dart';
import 'package:employee_master/data/datasources/local_database.dart';
import 'package:employee_master/presentaion/bloc/employee_bloc.dart';
import 'package:employee_master/presentaion/bloc/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init({bool useFirebase = true}) async {
  // ==============================================================
  //  DATA STORAGE SELECTION CONTROL
  // Switch this boolean to instantly toggle the entire app's backend!
  //
  // true  = OPTION 1: Firebase Cloud Storage
  // false = OPTION 2: SQLite Local Storage
  // ==============================================================

  // Blocs / Cubits
  sl.registerFactory(() => EmployeeBloc(sl()));
  sl.registerLazySingleton(() => ThemeCubit());

  // Conditional Repository Injection
  if (useFirebase) {
    // ------------------------------------------------------------
    // OPTION 1: USE FIREBASE FIRESTORE (CLOUD STORAGE)
    // ------------------------------------------------------------
    sl.registerLazySingleton<EmployeeRepository>(
      () => FirebaseRepositoryImpl(sl()),
    );
    // External Data Source (Firebase)
    sl.registerLazySingleton(() => FirebaseFirestore.instance);
  } else {
    // ------------------------------------------------------------
    // OPTION 2: USE SQLITE (LOCAL STORAGE)
    // ------------------------------------------------------------
    sl.registerLazySingleton<EmployeeRepository>(
      () => LocalRepositoryImpl(sl()),
    );
    // External Data Source (SQLite)
    sl.registerLazySingleton(() => DatabaseHelper.instance);
  }
}
