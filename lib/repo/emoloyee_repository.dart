import 'dart:convert';

import 'package:stream_line/models/employee.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmoloyeeRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<List<Employee>> getAllEmployee() async {
    try {
      final response = await _supabaseClient
          .from('employees')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Employee.fromMap(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Failed to load Employee: $e");
    }
  }

  Future<Employee> getEmployeeById(String id) async {
    try {
      final response =
          await _supabaseClient.from('employees').select().eq('id', id).single();

      return Employee.fromMap(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load Employee : $e');
    }
  }

  Future<Employee> addEmployee(Employee employee) async {
    try {
      final response = await _supabaseClient
          .from('employees')
          .insert(employee.toMap())
          .select()
          .single();

      return Employee.fromMap(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to add Employee: $e');
    }
  }

    Future<Employee> updateEmployee(Employee employee) async {
    try {
      final response = await _supabaseClient
          .from('employees')
          .update({
            ...employee.toMap(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', employee.id)
          .select()
          .single();

      return Employee.fromMap(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update employee: $e');
    }
  }

    Future<void> deleteEmployee(String id) async {
    try {
      await _supabaseClient
          .from('employees')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete employee: $e');
    }
  }

    Future<List<Employee>> searchEmployees(String query) async {
    try {
      final response = await _supabaseClient
          .from('employees')
          .select()
          .or('name.ilike.%$query%,email.ilike.%$query%,department.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Employee.fromMap(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search employees: $e');
    }
  }

    Future<List<Employee>> getEmployeesByDepartment(String department) async {
    try {
      final response = await _supabaseClient
          .from('employees')
          .select()
          .eq('department', department)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Employee.fromMap(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch employees by department: $e');
    }
  }

  //   Future<int> getEmployeeCount() async {
  //   try {
  //     final response = await _supabaseClient
  //         .from('employees')
  //         .select('id', const FetchOptions(count: CountOption.exact));

  //     return response.count ?? 0;
  //   } catch (e) {
  //     throw Exception('Failed to get employee count: $e');
  //   }
  // }

    Stream<List<Employee>> streamEmployees() {
    return _supabaseClient
        .from('employees')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data
            .map((json) => Employee.fromMap(json as Map<String, dynamic>))
            .toList());
  }
}
