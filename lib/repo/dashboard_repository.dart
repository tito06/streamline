import 'dart:async';

class DashboardRepository {
  
  Future<int> getEmployeeCount() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Return dummy data
    return 45;
  }

  Future<int> getPatientCount() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return 128;
  }

  Future<double> getTodayRevenue() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return 25000.0;
  }

  Future<List<Map<String, dynamic>>> getAppointmentData() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    return [
      {'status': 'Completed', 'count': 35},
      {'status': 'Pending', 'count': 12},
      {'status': 'Cancelled', 'count': 5},
      {'status': 'Scheduled', 'count': 18},
    ];
  }

  Future<List<Map<String, dynamic>>> getDepartmentData() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    return [
      {'name': 'Cardiology', 'patients': 42, 'revenue': 8500.0},
      {'name': 'Orthopedics', 'patients': 38, 'revenue': 7200.0},
      {'name': 'Neurology', 'patients': 28, 'revenue': 5600.0},
      {'name': 'Pediatrics', 'patients': 20, 'revenue': 3700.0},
    ];
  }
}
