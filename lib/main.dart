import 'package:flutter/material.dart';
import 'package:employee_master/presentaion/bloc/theme_cubit.dart';
import 'package:employee_master/presentaion/screens/login_screen.dart';
import 'package:employee_master/presentaion/bloc/employee_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase First
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Dependency Injection
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<EmployeeBloc>()..add(LoadEmployees())),
        BlocProvider(create: (_) => di.sl<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Employee Master',
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
