import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_line/cubit/dashboard/dashboard_metrics_state.dart';
import 'package:stream_line/models/AppointmentData.dart';
import 'package:stream_line/models/DepartmentData.dart';
import 'package:stream_line/repo/dashboard_repository.dart';

class DashboardMetricsCubit extends Cubit<DashboardMetricsState> {
  final DashboardRepository dashboardRepository;

  DashboardMetricsCubit(this.dashboardRepository)
      : super(DashboardMetricsState.initial());

  Future<void> loadDashboardMetrics() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await Future.wait([
        dashboardRepository.getEmployeeCount(),
        dashboardRepository.getPatientCount(),
        dashboardRepository.getTodayRevenue(),
        dashboardRepository.getAppointmentData(),
        dashboardRepository.getDepartmentData()
      ]);

      final appointmentList = (result[3] as List<Map<String, dynamic>>)
          .map((item) => AppointmentData.fromMap(item))
          .toList();

      final departmentList = (result[4] as List<Map<String, dynamic>>)
          .map((item) => DepartmentData.fromMap(item))
          .toList();

      emit(state.copyWith(
        isLoading: false,
        totalEmployees: result[0] as int,
        totalPatients: result[1] as int,
        todayRevenue: result[2] as double,
        appointmentChart: appointmentList,
        departmentPieChart: departmentList,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: "Failed to load data"));
    }
  }

  Future<void> refreshDashBoardMetrics() async {
    await loadDashboardMetrics();
  }
}
