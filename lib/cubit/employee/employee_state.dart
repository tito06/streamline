import 'package:stream_line/models/employee.dart';

class EmployeeState {
  final bool isLoading;
  final List<Employee> allEmployee;
  final Employee? selectedEmployee;
  final String? error;
  final String searchQuery;

  EmployeeState(
      {required this.isLoading,
      this.allEmployee = const [],
      this.selectedEmployee,
      this.error,
      this.searchQuery = ''});

  factory EmployeeState.initial() => EmployeeState(isLoading: false);

  EmployeeState copyWith({
    bool? isLoading,
    List<Employee>? allEmployee,
    Employee? selectedEmployee,
    String? error,
    String? searchQuery,
  }) {
    return EmployeeState(
      isLoading: isLoading ?? this.isLoading,
      allEmployee: allEmployee ?? this.allEmployee,
      selectedEmployee: selectedEmployee?? this.selectedEmployee,
      error: error ?? this.error,
      searchQuery: searchQuery?? this.searchQuery
      
      
      );
  }

    List<Employee> get filteredEmployees {
    if (searchQuery.isEmpty) return allEmployee;
    return allEmployee.where((emp) =>
      emp.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
      emp.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
      emp.department.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }
}
