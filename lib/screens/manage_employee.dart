import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_line/cubit/employee/employee_cubit.dart';
import 'package:stream_line/cubit/employee/employee_state.dart';
import 'package:stream_line/helper/responsive_helper.dart';
import 'package:stream_line/models/employee.dart';
import 'package:stream_line/repo/emoloyee_repository.dart';
import 'package:stream_line/screens/app_drawer.dart';

class ManageEmployee extends StatelessWidget {
  const ManageEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeCubit(EmoloyeeRepository())..loadEmployees(),
      child: const ManageEmployeeScreen(),
    );
  }
}

class ManageEmployeeScreen extends StatelessWidget {
  const ManageEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text("Manage Employee"),
              actions: [
                IconButton(
                    onPressed: () => _showAddEmployeeDialog,
                    icon: const Icon(Icons.add))
              ],
            ),
      body: Row(
        children: [
          if (isDesktop) const SizedBox(width: 280, child: AppDrawer()),
          Expanded(child: BlocBuilder<EmployeeCubit, EmployeeState>(
              builder: (context, state) {
            return Column(
                  children: [
                    // Header Section
                    Container(
                      padding: EdgeInsets.all(isDesktop ? 24 : 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isDesktop) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Manage Employees',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _showAddEmployeeDialog(context),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Employee'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                          // Search Bar
                          TextField(
                            onChanged: (value) {
                              context.read<EmployeeCubit>().searchEmployee(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search employees...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Employee List
                    Expanded(
                      child: state.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : state.error != null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(state.error!),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          context.read<EmployeeCubit>().loadEmployees();
                                        },
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                )
                              : state.filteredEmployees.isEmpty
                                  ? const Center(
                                      child: Text('No employees found'),
                                    )
                                  : LayoutBuilder(
                                      builder: (context, constraints) {
                                        if (ResponsiveLayout.isDesktop(context)) {
                                          return _EmployeeDataTable(
                                            employees: state.filteredEmployees,
                                          );
                                        } else {
                                          return _EmployeeListView(
                                            employees: state.filteredEmployees,
                                          );
                                        }
                                      },
                                    ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: !isDesktop
          ? FloatingActionButton(
              onPressed: () => _showAddEmployeeDialog(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<EmployeeCubit>(),
        child: const AddEmployeeDialog(),
      ),
    );
  }
}

// Desktop Data Table View
class _EmployeeDataTable extends StatelessWidget {
  final List<Employee> employees;

  const _EmployeeDataTable({required this.employees});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Department')),
            DataColumn(label: Text('Designation')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: employees.map((employee) {
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    children: [
                      CircleAvatar(
                        child: Text(employee.name[0]),
                      ),
                      const SizedBox(width: 8),
                      Text(employee.name),
                    ],
                  ),
                ),
                DataCell(Text(employee.email)),
                DataCell(Text(employee.phone)),
                DataCell(Text(employee.department)),
                DataCell(Text(employee.designation)),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: employee.status == 'active'
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      employee.status.toUpperCase(),
                      style: TextStyle(
                        color: employee.status == 'active'
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _showEditDialog(context, employee),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: () => _showDeleteDialog(context, employee),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<EmployeeCubit>(),
        child: AddEmployeeDialog(employee: employee),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: Text('Are you sure you want to delete ${employee.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<EmployeeCubit>().deleteEmployee(employee.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Mobile/Tablet List View
class _EmployeeListView extends StatelessWidget {
  final List<Employee> employees;

  const _EmployeeListView({required this.employees});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                employee.name[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              employee.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(employee.email),
                Text('${employee.department} - ${employee.designation}'),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: employee.status == 'active'
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                employee.status.toUpperCase(),
                style: TextStyle(
                  color: employee.status == 'active' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            onTap: () => _showEmployeeDetails(context, employee),
          ),
        );
      },
    );
  }

  void _showEmployeeDetails(BuildContext context, Employee employee) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _EmployeeDetailsSheet(employee: employee),
    );
  }
}

// Employee Details Bottom Sheet
class _EmployeeDetailsSheet extends StatelessWidget {
  final Employee employee;

  const _EmployeeDetailsSheet({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue,
                child: Text(
                  employee.name[0],
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(employee.designation),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _DetailRow(icon: Icons.email, label: 'Email', value: employee.email),
          _DetailRow(icon: Icons.phone, label: 'Phone', value: employee.phone),
          _DetailRow(icon: Icons.business, label: 'Department', value: employee.department),
          _DetailRow(icon: Icons.calendar_today, label: 'Joining Date', value: employee.joiningDate.toString()),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (dialogContext) => BlocProvider.value(
                        value: context.read<EmployeeCubit>(),
                        child: AddEmployeeDialog(employee: employee),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<EmployeeCubit>().deleteEmployee(employee.id);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// Add/Edit Employee Dialog
class AddEmployeeDialog extends StatefulWidget {
  final Employee? employee;

  const AddEmployeeDialog({Key? key, this.employee}) : super(key: key);

  @override
  State<AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<AddEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _departmentController;
  late TextEditingController _designationController;
  String _status = 'active';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name);
    _emailController = TextEditingController(text: widget.employee?.email);
    _phoneController = TextEditingController(text: widget.employee?.phone);
    _departmentController = TextEditingController(text: widget.employee?.department);
    _designationController = TextEditingController(text: widget.employee?.designation);
    _status = widget.employee?.status ?? 'active';
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.employee != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Employee' : 'Add Employee'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(labelText: 'Department'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _designationController,
                decoration: const InputDecoration(labelText: 'Designation'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
                onChanged: (value) => setState(() => _status = value!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveEmployee,
          child: Text(isEdit ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      final employee = Employee(
        id: widget.employee?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        department: _departmentController.text,
        designation: _designationController.text,
        joiningDate: widget.employee?.joiningDate ?? DateTime.now(),
        status: _status,
      );

      if (widget.employee != null) {
        context.read<EmployeeCubit>().updateEmployee(employee);
      } else {
        context.read<EmployeeCubit>().addEmployee(employee);
      }

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _designationController.dispose();
    super.dispose();
  }
}
