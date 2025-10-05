class Employee {
  final String id;     
  final String name;
  final String role;
  final String age;
  final String gender;

  Employee({
    this.id = '',
    required this.name,
    required this.role,
    required this.age,
    required this.gender,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'age': age,
      'gender': gender,
    };
  }

  
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      age: map['age'] ?? '',
      gender: map['gender'] ?? '',
    );
  }
}
