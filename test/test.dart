// test/hospital_service_test.dart
import 'package:test/test.dart';
import '../lib/domain/hospital_services.dart';
import '../lib/data/file_repository.dart';

// For domain tests we don't need actual files; provide a repository with temp paths
void main() {
  late Hospitalservice service;

  setUp(() {
    // Use file paths that won't be used in test environment (or provide mock repository)
    service = Hospitalservice(repository: FileRepository(
      patientsPath: 'test_data/patients_test.json',
      doctorsPath: 'test_data/doctors_test.json',
      appointmentsPath: 'test_data/appointments_test.json',
    ));
  });

  test('Register Patient', () {
    final p = service.registerPatient(
      name: 'Alice',
      age: 30,
      gender: 'F',
      phone: '0123456789',
      medicalRecordNo: 'MRN001',
    );
    expect(service.allPatients.length, 1);
    expect(p.name, 'Alice');
    expect(p.id.startsWith('P'), true);
  });

  test('Register Doctor', () {
    final d = service.registerDoctor(
      name: 'Dr Bob',
      age: 45,
      gender: 'M',
      phone: '0987654321',
      specialization: 'Cardiology',
    );
    expect(service.allDoctors.length, 1);
    expect(d.specialization, 'Cardiology');
    expect(d.id.startsWith('D'), true);
  });

  test('Schedule Appointment (happy path)', () {
    final p = service.registerPatient(
      name: 'Pat',
      age: 22,
      gender: 'M',
      phone: '011111111',
      medicalRecordNo: 'MRN002',
    );
    final d = service.registerDoctor(
      name: 'Dr A',
      age: 40,
      gender: 'F',
      phone: '02222222',
      specialization: 'General',
    );
    final dt = DateTime(2025, 10, 10, 9, 0);
    final appt = service.scheduleAppointment(
      patientId: p.id,
      doctorId: d.id,
      dateTime: dt,
    );
    expect(appt, isNotNull);
    expect(service.allAppointments.length, 1);
    expect(service.allAppointments.first.dateTime, dt);
  });

  test('Prevent doctor double booking', () {
    final p1 = service.registerPatient(
      name: 'P1',
      age: 20,
      gender: 'M',
      phone: '01',
      medicalRecordNo: 'MRN3',
    );
    final p2 = service.registerPatient(
      name: 'P2',
      age: 21,
      gender: 'F',
      phone: '02',
      medicalRecordNo: 'MRN4',
    );
    final d = service.registerDoctor(
      name: 'Dr X',
      age: 50,
      gender: 'M',
      phone: '03',
      specialization: 'Surg',
    );
    final dt = DateTime(2025, 11, 11, 10, 0);
    final a1 = service.scheduleAppointment(
      patientId: p1.id,
      doctorId: d.id,
      dateTime: dt,
    );
    expect(a1, isNotNull);
    final a2 = service.scheduleAppointment(
      patientId: p2.id,
      doctorId: d.id,
      dateTime: dt,
    );
    expect(a2, isNull); // second booking for same doctor/time should fail
  });

  test('Prevent patient double booking', () {
    final p = service.registerPatient(
      name: 'Solo',
      age: 33,
      gender: 'F',
      phone: '04',
      medicalRecordNo: 'MRN5',
    );
    final d1 = service.registerDoctor(
      name: 'Dr1',
      age: 35,
      gender: 'M',
      phone: '05',
      specialization: 'ENT',
    );
    final d2 = service.registerDoctor(
      name: 'Dr2',
      age: 45,
      gender: 'F',
      phone: '06',
      specialization: 'Obs',
    );
    final dt = DateTime(2025, 12, 12, 11, 0);
    final a1 = service.scheduleAppointment(
      patientId: p.id,
      doctorId: d1.id,
      dateTime: dt,
    );
    expect(a1, isNotNull);
    final a2 = service.scheduleAppointment(
      patientId: p.id,
      doctorId: d2.id,
      dateTime: dt,
    );
    expect(a2, isNull); // patient already busy
  });

  test('Reject appointment with unknown patient', () {
    final d = service.registerDoctor(
      name: 'Dr Y',
      age: 40,
      gender: 'M',
      phone: '07',
      specialization: 'Derm',
    );
    final dt = DateTime(2025, 9, 9, 8, 0);
    final appt = service.scheduleAppointment(
      patientId: 'P999999', // not exist
      doctorId: d.id,
      dateTime: dt,
    );
    expect(appt, isNull);
  });

  test('Reject appointment with unknown doctor', () {
    final p = service.registerPatient(
      name: 'Ghost',
      age: 28,
      gender: 'M',
      phone: '08',
      medicalRecordNo: 'MRN6',
    );
    final dt = DateTime(2025, 8, 8, 9, 0);
    final appt = service.scheduleAppointment(
      patientId: p.id,
      doctorId: 'D999999', // not exist
      dateTime: dt,
    );
    expect(appt, isNull);
  });

  test('List appointments works', () {
    final p = service.registerPatient(
      name: 'ListP',
      age: 21,
      gender: 'F',
      phone: '09',
      medicalRecordNo: 'MRN7',
    );
    final d = service.registerDoctor(
      name: 'ListD',
      age: 38,
      gender: 'M',
      phone: '10',
      specialization: 'Cardio',
    );
    final dt1 = DateTime(2025, 7, 7, 9, 0);
    final dt2 = DateTime(2025, 7, 7, 10, 0);
    service.scheduleAppointment(patientId: p.id, doctorId: d.id, dateTime: dt1);
    service.scheduleAppointment(patientId: p.id, doctorId: d.id, dateTime: dt2);
    expect(service.allAppointments.length, 2);
  });
}
