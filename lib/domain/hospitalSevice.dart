import 'appointment.dart';
import 'doctor.dart';
import 'patient.dart';

class Hospitalsevice {

  final List<Patient> _patients = [] ;
  int _nextPatientId = 1;

  final List<Doctor>  _doctors = [];
  int _nextDoctorId = 1;
  final List<Appointment>  _appointments = [];
  int _nextAppointmentId = 1;

  List<Patient> get allPatient => _patients;
  List<Doctor> get allDoctor => _doctors;
  List<Appointment> get allAppointment => _appointments;

  Patient registerPatient({
    required String name,
    required int age,
    required String gender,
    required String phone,
    required String medicalRecordNo
  }){
      String numberPart = _nextPatientId.toString().padLeft(6,'0');
      String newId = 'P$numberPart';

      _nextPatientId++;

      Patient newPatient = Patient(
        id:newId,
        name: name,
        age: age,
        gender: gender,
        phone: phone,
        medicalRecordNo: medicalRecordNo,
      );

      _patients.add(newPatient);


      return newPatient;

  }


  Doctor registerDoctor({
    required String name,
    required int age,
    required String gender,
    required String phone,
    required String specialization,
  }){
    String numberPart = _nextDoctorId.toString().padLeft(6,'0');
      String newId = 'D$numberPart';

      _nextDoctorId++;

      Doctor newDotor = Doctor(
        id:newId,
        name: name,
        age: age,
        gender: gender,
        phone: phone,
        specialization: specialization,
      );

      _doctors.add(newDotor);


      return newDotor;

  }


  Appointment scdeduleAppointment({
    required Patient patient,
    required Doctor doctor,
    required DateTime dateTime,
  }){
    //add logic if doctor is busy and patient`

    
  String numberPart = _nextAppointmentId.toString().padLeft(6,'0');
  String newId = 'A$numberPart';

  _nextAppointmentId++;

  Appointment newAppointment = Appointment(id: newId, patient: patient, doctor: doctor, dateTime: dateTime);

  _appointments.add(newAppointment);

  return newAppointment;

  }

  


}