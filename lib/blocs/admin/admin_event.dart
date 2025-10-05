import 'package:stream_line/models/employee.dart';

abstract class AdminEvent {}

class AddEmployee extends AdminEvent {
  final Employee employee;

  AddEmployee(this.employee);
}

class LoadEmployees extends AdminEvent {}

class LoadPatients extends AdminEvent {}

class LoadReports extends AdminEvent {}

class LoadMedicineStock extends AdminEvent {}
