import 'package:flutter/material.dart';
import 'package:employee_master/presentaion/bloc/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/employee_bloc.dart';
import '../../domain/entities/employee.dart';
import 'add_edit_screen.dart';
import 'login_screen.dart';
import '../../core/widgets/glass_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _confirmDelete(BuildContext context, Employee emp) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: const Text('Delete Employee'),
              content: Text('Are you sure you want to delete ${emp.empName}?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('CANCEL')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    context
                        .read<EmployeeBloc>()
                        .add(DeleteEmployee(emp.empCode));
                    Navigator.pop(ctx);
                  },
                  child: const Text('DELETE'),
                )
              ],
            ));
  }

  void _showEmployeeDetails(BuildContext context, Employee emp, bool isDark) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10)),
                )),
                const SizedBox(height: 20),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : const Color(0xFF1E3C72).withValues(alpha: 0.1),
                      child: Text(
                        emp.empName.isNotEmpty
                            ? emp.empName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1E3C72)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(emp.empName,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDark ? Colors.white : Colors.black87)),
                          Text(emp.empCode,
                              style: const TextStyle(
                                  color: Colors.blueAccent, fontSize: 16)),
                        ])),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDetailRow(Icons.phone, 'Mobile', emp.mobile, isDark),
                _buildDetailRow(Icons.cake, 'Date of Birth',
                    emp.dob.isEmpty ? 'N/A' : emp.dob, isDark),
                _buildDetailRow(
                    Icons.work,
                    'Date of Joining',
                    emp.dateOfJoining.isEmpty ? 'N/A' : emp.dateOfJoining,
                    isDark),
                _buildDetailRow(Icons.attach_money, 'Salary',
                    emp.salary > 0 ? '₹${emp.salary}' : 'N/A', isDark),
                _buildDetailRow(Icons.location_on, 'Address',
                    emp.address.isEmpty ? 'N/A' : emp.address, isDark),
                _buildDetailRow(Icons.note, 'Remark',
                    emp.remark.isEmpty ? 'N/A' : emp.remark, isDark),
                const SizedBox(height: 10),
              ],
            )));
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value, bool isDark) {
    if (value.isEmpty || value == 'N/A') return const SizedBox.shrink();
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon,
                size: 20, color: isDark ? Colors.white54 : Colors.black54),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white54 : Colors.black54)),
                  Text(value,
                      style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black87)),
                ]))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees',
            style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600)),
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
          IconButton(
            icon:
                Icon(Icons.logout, color: isDark ? Colors.white : Colors.black),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        title: const Text('Confirm Logout'),
                        content: const Text(
                            'Are you sure you want to end your session?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('CANCEL')),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3C72),
                                foregroundColor: Colors.white),
                            onPressed: () async {
                              Navigator.pop(ctx);
                              await FirebaseAuth.instance.signOut();
                              if (!context.mounted) return;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const LoginScreen()));
                            },
                            child: const Text('LOGOUT'),
                          )
                        ],
                      ));
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (query) =>
                    context.read<EmployeeBloc>().add(SearchEmployees(query)),
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                    hintText: 'Search Employee...',
                    hintStyle: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black38),
                    border: InputBorder.none,
                    icon: Icon(Icons.search,
                        color: isDark ? Colors.white70 : Colors.black54)),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0F2027), const Color(0xFF2C5364)]
                : [const Color(0xFFE6F0FA), const Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: BlocListener<EmployeeBloc, EmployeeState>(
            listener: (context, state) {
              if (state is EmployeeOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (state is EmployeeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.msg),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, state) {
                if (state is EmployeeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is EmployeeLoaded) {
                  if (state.employees.isEmpty) {
                    return Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people_outline,
                            size: 80,
                            color: isDark ? Colors.white30 : Colors.black26),
                        const SizedBox(height: 16),
                        Text("No Employees Found",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    isDark ? Colors.white70 : Colors.black54)),
                      ],
                    ));
                  }

                  return LayoutBuilder(builder: (context, constraints) {
                    final bool isDesktop = constraints.maxWidth > 900;
                    final int crossAxisCount =
                        constraints.maxWidth > 1200 ? 3 : 2;

                    Widget buildEmployeeCard(Employee emp) {
                      return Card(
                          elevation: 3,
                          margin: isDesktop
                              ? EdgeInsets.zero
                              : const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () =>
                                _showEmployeeDetails(context, emp, isDark),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: isDark
                                        ? Colors.white.withValues(alpha: 0.1)
                                        : const Color(0xFF1E3C72)
                                            .withValues(alpha: 0.1),
                                    child: Text(
                                      emp.empName.isNotEmpty
                                          ? emp.empName[0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : const Color(0xFF1E3C72)),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                        Text(emp.empName,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black87),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 4),
                                        Text('${emp.empCode} • ${emp.mobile}',
                                            style: TextStyle(
                                                color: isDark
                                                    ? Colors.white70
                                                    : Colors.black54,
                                                fontSize: 13),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                      ])),
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            icon: const Icon(
                                                Icons.edit_outlined,
                                                color: Colors.blueAccent),
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        AddEditEmployeeScreen(
                                                            employee: emp)))),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline,
                                              color: Colors.redAccent),
                                          onPressed: () =>
                                              _confirmDelete(context, emp),
                                        ),
                                      ])
                                ],
                              ),
                            ),
                          ));
                    }

                    if (isDesktop) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(24),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio:
                              constraints.maxWidth > 1200 ? 3.5 : 3.0,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: state.employees.length,
                        itemBuilder: (context, index) =>
                            buildEmployeeCard(state.employees[index]),
                      );
                    } else {
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: state.employees.length,
                            itemBuilder: (context, index) =>
                                buildEmployeeCard(state.employees[index]),
                          ),
                        ),
                      );
                    }
                  });
                }
                return const Center(child: Text("Error loading data"));
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E3C72),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddEditEmployeeScreen())),
      ),
    );
  }
}
