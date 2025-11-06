import 'doctor.dart';
import 'patient.dart';

class Appointment {
  final String id;
  final Patient patient;
  final Doctor doctor;
  final DateTime dateTime;

  Appointment(
      {required this.id,
      required this.patient,
      required this.doctor,
      required this.dateTime});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient': patient.toJson(),
      'doctor': doctor..toJson(),
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
        id: json['id'],
        patient: Patient.fromJson(json['patient']),
        doctor: Doctor.fromJson(json['doctor']),
        dateTime: DateTime.parse(json['dateTime']));
  }
}
