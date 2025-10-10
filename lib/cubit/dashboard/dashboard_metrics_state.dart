import 'package:stream_line/models/AppointmentData.dart';
import 'package:stream_line/models/DepartmentData.dart';

class DashboardMetricsState {
  final bool isLoading;
  final int totalEmployees;
  final int totalPatients;
  final double todayRevenue;
  final List<AppointmentData> appointmentChart;
  final List<DepartmentData> departmentPieChart;
  final String? error;
  
  const DashboardMetricsState({
    required this.isLoading,
    this.totalEmployees = 0,
    this.totalPatients = 0,
    this.todayRevenue = 0.0,
    this.appointmentChart = const [],
    this.departmentPieChart = const [],
    this.error,
  });
  
  factory DashboardMetricsState.initial() => const DashboardMetricsState(
    isLoading: false,
  );
  
  DashboardMetricsState copyWith({
    bool? isLoading,
    int? totalEmployees,
    int? totalPatients,
    double? todayRevenue,
    List<AppointmentData>? appointmentChart,
    List<DepartmentData>? departmentPieChart,
    String? error,
  }) {
    return DashboardMetricsState(
      isLoading: isLoading ?? this.isLoading,
      totalEmployees: totalEmployees ?? this.totalEmployees,
      totalPatients: totalPatients ?? this.totalPatients,
      todayRevenue: todayRevenue ?? this.todayRevenue,
      appointmentChart: appointmentChart ?? this.appointmentChart,
      departmentPieChart: departmentPieChart ?? this.departmentPieChart,
      error: error,
    );
  }
}