import 'package:flutter/material.dart';
import 'package:employee_master/presentaion/bloc/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/employee.dart';
import '../bloc/employee_bloc.dart';
import '../../core/widgets/glass_container.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final Employee? employee;
  const AddEditEmployeeScreen({super.key, this.employee});

  @override
  State<AddEditEmployeeScreen> createState() => _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeCtrl,
      _nameCtrl,
      _mobileCtrl,
      _dobCtrl,
      _dojCtrl,
      _salaryCtrl,
      _addressCtrl,
      _remarkCtrl;

  @override
  void initState() {
    super.initState();
    final e = widget.employee;
    final state = context.read<EmployeeBloc>().state;

    String initialCode = e?.empCode ?? '';
    if (e == null && state is EmployeeLoaded) {
      final employees = state.employees;
      if (employees.isEmpty) {
        initialCode = 'EMP001';
      } else {
        int maxId = 0;
        for (var emp in employees) {
          final match = RegExp(r'(\d+)').firstMatch(emp.empCode);
          if (match != null) {
            int currentId = int.tryParse(match.group(1)!) ?? 0;
            if (currentId > maxId) maxId = currentId;
          }
        }
        initialCode = 'EMP${(maxId + 1).toString().padLeft(3, '0')}';
      }
    }

    final tenYearsAgo = DateTime.now().subtract(const Duration(days: 3652));

    final defaultDate = tenYearsAgo.toIso8601String().split('T')[0];

    final toDate = DateTime.now();
    final toDayDate = toDate.toIso8601String().split('T')[0];

    _codeCtrl = TextEditingController(text: initialCode);
    _nameCtrl = TextEditingController(text: e?.empName ?? '');
    _mobileCtrl = TextEditingController(text: e?.mobile ?? '');
    _dobCtrl = TextEditingController(text: e?.dob ?? defaultDate);
    _dojCtrl = TextEditingController(text: e?.dateOfJoining ?? toDayDate);
    _salaryCtrl = TextEditingController(text: e?.salary.toString() ?? '');
    _addressCtrl = TextEditingController(text: e?.address ?? '');
    _remarkCtrl = TextEditingController(text: e?.remark ?? '');
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final emp = Employee(
        empCode: _codeCtrl.text,
        empName: _nameCtrl.text,
        mobile: _mobileCtrl.text,
        dob: _dobCtrl.text,
        dateOfJoining: _dojCtrl.text,
        salary: double.tryParse(_salaryCtrl.text) ?? 0.0,
        address: _addressCtrl.text,
        remark: _remarkCtrl.text,
      );
      context
          .read<EmployeeBloc>()
          .add(SaveEmployee(emp, widget.employee != null));
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController ctrl, bool isDob) async {
    final DateTime now = DateTime.now();
    final DateTime tenYearsAgo = now.subtract(const Duration(days: 3652));

    final DateTime currentDate = now.subtract(const Duration(days: 3652));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDob
          ? (DateTime.tryParse(ctrl.text) ?? tenYearsAgo)
          : (DateTime.tryParse(ctrl.text) ?? currentDate),
      firstDate: DateTime(1960),
      lastDate: isDob ? tenYearsAgo : DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF1E3C72),
              onPrimary: Colors.white,
              onSurface: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        ctrl.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  Widget _buildFormFields(bool isDark, double maxWidth) {
    final bool isDesktop = maxWidth > 800;

    if (isDesktop) {
      return Column(
        children: [
          Row(children: [
            Expanded(
                child: _buildField(_codeCtrl, 'EmpCode (Auto-generated)',
                    isEnabled: false, isDark: isDark)),
            const SizedBox(width: 16),
            Expanded(
                child: _buildField(_nameCtrl, 'Employee Name', isDark: isDark)),
          ]),
          Row(children: [
            Expanded(
                child: _buildField(_mobileCtrl, 'Mobile',
                    isPhone: true, isDark: isDark)),
            const SizedBox(width: 16),
            Expanded(
                child: _buildField(_salaryCtrl, 'Salary',
                    isNumber: true, isDark: isDark)),
          ]),
          Row(children: [
            Expanded(
                child: _buildField(_dobCtrl, 'Date of Birth',
                    isDate: true, isDark: isDark)),
            const SizedBox(width: 16),
            Expanded(
                child: _buildField(_dojCtrl, 'Date of Joining',
                    isDate: true, isDark: isDark)),
          ]),
          _buildField(_addressCtrl, 'Address', maxLines: 2, isDark: isDark),
          _buildField(_remarkCtrl, 'Remark', maxLines: 2, isDark: isDark),
          const SizedBox(height: 30),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xFF1E3C72),
                  foregroundColor: Colors.white,
                  elevation: 6),
              onPressed: _save,
              child: const Text('SAVE EMPLOYEE',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.5)))
        ],
      );
    } else {
      return Column(
        children: [
          _buildField(_codeCtrl, 'EmpCode (Auto-generated)',
              isEnabled: false, isDark: isDark),
          _buildField(_nameCtrl, 'Employee Name', isDark: isDark),
          _buildField(_mobileCtrl, 'Mobile', isPhone: true, isDark: isDark),
          _buildField(_dobCtrl, 'Date of Birth', isDate: true, isDark: isDark),
          _buildField(_dojCtrl, 'Date of Joining',
              isDate: true, isDark: isDark),
          _buildField(_salaryCtrl, 'Salary', isNumber: true, isDark: isDark),
          _buildField(_addressCtrl, 'Address', maxLines: 3, isDark: isDark),
          _buildField(_remarkCtrl, 'Remark', isDark: isDark),
          const SizedBox(height: 20),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xFF1E3C72),
                  foregroundColor: Colors.white,
                  elevation: 3),
              onPressed: _save,
              child: const Text('SAVE EMPLOYEE',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)))
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocListener<EmployeeBloc, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.message), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        } else if (state is EmployeeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.msg), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
              widget.employee == null ? 'Add Employee' : 'Edit Employee',
              style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode,
                  color: isDark ? Colors.amber : const Color(0xFF1E3C72)),
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [const Color(0xFF0F2027), const Color(0xFF2C5364)]
                  : [
                      const Color(0xFF4A90E2).withValues(alpha: 0.1),
                      const Color(0xFFFFFFFF)
                    ],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: GlassContainer(
                      child: Form(
                        key: _formKey,
                        child: _buildFormFields(isDark, constraints.maxWidth),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label,
      {bool isNumber = false,
      bool isPhone = false,
      bool isDate = false,
      bool isEnabled = true,
      int maxLines = 1,
      required bool isDark}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: ctrl,
        readOnly: isDate,
        onTap: isDate
            ? () => _selectDate(context, ctrl, label.contains('Birth'))
            : null,
        enabled: isEnabled,
        maxLines: maxLines,
        keyboardType: isDate
            ? TextInputType.none
            : (isNumber
                ? TextInputType.number
                : (isPhone ? TextInputType.phone : TextInputType.text)),
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          prefixIcon: isDate
              ? Icon(Icons.calendar_month,
                  color: isDark ? Colors.white70 : Colors.black54)
              : null,
          filled: true,
          fillColor: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          errorStyle: const TextStyle(
              color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return 'This field is required';
          if (isPhone && !RegExp(r'^\d{10}$').hasMatch(v.trim())) {
            return 'Enter a strict 10-digit mobile number';
          }
          if (isNumber &&
              (double.tryParse(v.trim()) == null ||
                  double.parse(v.trim()) < 0)) {
            return 'Enter a valid positive number';
          }
          if (isDate && !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(v.trim())) {
            return 'Strict format: YYYY-MM-DD required';
          }
          return null;
        },
      ),
    );
  }
}
