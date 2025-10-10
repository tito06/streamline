class DepartmentData {
  final String name;
  final int patients;

  const DepartmentData({
    required this.name,
    required this.patients,
  });

  factory DepartmentData.fromMap(Map<String, dynamic> map) {
    return DepartmentData(
      name: map['name'] as String,
      patients: map['patients'] as int,
    );
  }
}