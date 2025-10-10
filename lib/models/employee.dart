class Employee {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String department;
  final String designation;
  final DateTime joiningDate;
  final String status;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.designation,
    required this.joiningDate,
    required this.status,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      department: map['department'] as String,
      designation: map['designation'] as String,
      joiningDate: DateTime.parse(map['joining_date'] as String),
      status: map['status'] as String? ?? 'active',
      profileImage: map['profile_image'] as String?,
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at'] as String) 
          : null,
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'designation': designation,
      'joining_date': joiningDate.toIso8601String().split('T')[0],
      'status': status,
      'profile_image': profileImage,
    };
  }

  Map<String, dynamic> toMapWithId() {
    return {
      'id': id,
      ...toMap(),
    };
  }

  Employee copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? department,
    String? designation,
    DateTime? joiningDate,
    String? status,
    String? profileImage,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      joiningDate: joiningDate ?? this.joiningDate,
      status: status ?? this.status,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
