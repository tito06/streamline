class AppointmentData {
  final String status;
  final int count;

  const AppointmentData({
    required this.status,
    required this.count,
  });

  factory AppointmentData.fromMap(Map<String, dynamic> map) {
    return AppointmentData(
      status: map['status'] as String,
      count: map['count'] as int,
    );
  }
}
