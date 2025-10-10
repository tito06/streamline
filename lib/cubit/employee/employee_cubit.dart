import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_line/cubit/employee/employee_state.dart';
import 'package:stream_line/models/employee.dart';
import 'package:stream_line/repo/emoloyee_repository.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmoloyeeRepository emoloyeeRepository;

  EmployeeCubit(this.emoloyeeRepository) : super(EmployeeState.initial());

  Future<void> loadEmployees() async {
    emit(state.copyWith(isLoading: true));

    try {
      final employee = await emoloyeeRepository.getAllEmployee();

      emit(
          state.copyWith(isLoading: false, allEmployee: employee, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void searchEmployee(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  Future<void> selectEmployeeById(String id) async {
    try {
      final employee = await emoloyeeRepository.getEmployeeById(id);

      emit(state.copyWith(selectedEmployee: employee));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> addEmployee(Employee employee) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await emoloyeeRepository.addEmployee(employee);
      await emoloyeeRepository.getAllEmployee();
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      await emoloyeeRepository.updateEmployee(employee);
      await emoloyeeRepository.getAllEmployee();
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      await emoloyeeRepository.deleteEmployee(id);
      await emoloyeeRepository.getAllEmployee();
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
