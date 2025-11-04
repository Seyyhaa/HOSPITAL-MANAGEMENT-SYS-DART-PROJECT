import 'doctor.dart';
import 'patient.dart';


class Appointment{
  final String id;
  final Patient patient;
  final Doctor doctor;
  final DateTime dateTime;

  
  Appointment({required this.id, required this.patient, required this.doctor,required this.dateTime});
  

}