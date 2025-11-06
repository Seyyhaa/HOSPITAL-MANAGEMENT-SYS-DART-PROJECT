import 'appointment.dart';
import 'doctor.dart';
import 'patient.dart';
import '../data/file_repository.dart';

class Hospitalservice {
  final List<Patient> _patients = [];
  final List<Doctor> _doctors = [];
  final List<Appointment> _appointments = [];

  int _nextPatientId = 1;
  int _nextDoctorId = 1;
  int _nextAppointmentId = 1;

  List<Patient> get allPatients => _patients;
  List<Doctor> get allDoctors => _doctors;
  List<Appointment> get allAppointments => _appointments;

  final FileRepository repo;

  Hospitalservice({FileRepository? repository})
      : repo = repository ?? FileRepository();

  Patient registerPatient({
    required String name,
    required int age,
    required String gender,
    required String phone,
    required String medicalRecordNo,
  }) {
    String numberPart = _nextPatientId.toString().padLeft(6, '0');
    String newId = 'P$numberPart';
    _nextPatientId++;

    Patient newPatient = Patient(
      id: newId,
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
  }) {
    String numberPart = _nextDoctorId.toString().padLeft(6, '0');
    String newId = 'D$numberPart';
    _nextDoctorId++;

    Doctor newDoctor = Doctor(
      id: newId,
      name: name,
      age: age,
      gender: gender,
      phone: phone,
      specialization: specialization,
    );
    _doctors.add(newDoctor);
    return newDoctor;
  }

  bool validateDoctorAvailability(String doctorId, DateTime dateTime) {
    return !_appointments.any(
      (a) => a.doctor.id == doctorId && a.dateTime == dateTime,
    );
  }

  bool validatePatientAvailability(String patientId, DateTime dateTime) {
    return !_appointments.any(
      (a) => a.patient.id == patientId && a.dateTime == dateTime,
    );
  }

  Appointment? scheduleAppointment({
    required String patientId,
    required String doctorId,
    required DateTime dateTime,
  }) {
    Patient? patient = findPatientById(patientId);
    Doctor? doctor = findDoctorById(doctorId);


    if (patient == null) {
      print('Error: Patient not found!');
      return null;
    }
    if (doctor == null) {
      print('Error: Doctor not found!');
      return null;
    }

    if (!validateDoctorAvailability(doctorId, dateTime)) {
      print('Doctor is already booked at this time!');
      return null;
    }

   
    if (!validatePatientAvailability(patientId, dateTime)) {
      print('Patient already has appointment at this time!');
      return null;
    }

    String numberPart = _nextAppointmentId.toString().padLeft(6, '0');
    String newId = 'A$numberPart';

    _nextAppointmentId++;

    Appointment newAppointment = Appointment(
      id: newId,
      patient: patient,
      doctor: doctor,
      dateTime: dateTime,
    );

    _appointments.add(newAppointment);

    return newAppointment;
  }

  Patient? findPatientById(String id) {
    for (Patient patient in _patients) {
      if (patient.id == id) {
        return patient;
      }
    }
    return null;
  }

  Doctor? findDoctorById(String id) {
    for (Doctor doctor in _doctors) {
      if (doctor.id == id) {
        return doctor;
      }
    }
    return null;
  }

  List<Appointment> getDoctorSchedule(String doctorId) {
    List<Appointment> schedule = [];

    for (Appointment appointment in _appointments) {
      if (appointment.doctor.id == doctorId) {
        schedule.add(appointment);
      }
    }
    return schedule;
  }

  bool cancelAppointment(String appointmentId) {
    int before = _appointments.length;
    _appointments.removeWhere((a) => a.id == appointmentId);
    return before != _appointments.length;
  }

  Future<void> saveAll() async {
    final patientsJson = _patients.map((p) => p.toJson()).toList();
    final doctorsJson = _doctors.map((d) => d.toJson()).toList();
    final appointmentsJson = _appointments.map((a) => a.toJson()).toList();

    await repo.savePatients(patientsJson);
    await repo.saveDoctors(doctorsJson);
    await repo.saveAppointments(appointmentsJson);
  }

  Future<void> loadAll() async {
    try {
      final results = await Future.wait([
        repo.loadPatients(),
        repo.loadDoctors(),
        repo.loadAppointments(),
      ]);

      final patientsJson = List<Map<String, dynamic>>.from(results[0]);
      final doctorsJson = List<Map<String, dynamic>>.from(results[1]);
      final appointmentsJson = List<Map<String, dynamic>>.from(results[2]);

      final loadedPatients = patientsJson.map(Patient.fromJson).toList();
      final loadedDoctors = doctorsJson.map(Doctor.fromJson).toList();
      final loadedAppointments =
          appointmentsJson.map(Appointment.fromJson).toList();

      loadData(
        loadedPatients: loadedPatients,
        loadedDoctors: loadedDoctors,
        loadedAppointments: loadedAppointments,
      );
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  void loadData({
    required List<Patient> loadedPatients,
    required List<Doctor> loadedDoctors,
    required List<Appointment> loadedAppointments,
  }) {

    _patients.clear();
    _doctors.clear();
    _appointments.clear();


    _patients.addAll(loadedPatients);
    _doctors.addAll(loadedDoctors);
    _appointments.addAll(loadedAppointments);

 
    if (_patients.isNotEmpty) {
      Patient lastPatient = _patients.last;
      String lastId = lastPatient.id;
      int maxId = int.parse(lastId.substring(1));
      _nextPatientId = maxId + 1;
    }
    if (_doctors.isNotEmpty) {
      Doctor lastDoctor = _doctors.last;
      String lastId = lastDoctor.id;
      int maxId = int.parse(lastId.substring(1));
      _nextDoctorId = maxId + 1;
    }
    if (_appointments.isNotEmpty) {
      Appointment lastAppointment = _appointments.last;
      String lastId = lastAppointment.id;
      int maxId = int.parse(lastId.substring(1));
      _nextAppointmentId = maxId + 1;
    }

    print('Data loaded successfully into final lists!');
  }
}
