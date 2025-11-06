
import 'package:test/test.dart';
import 'package:hospital_app/data/file_repository.dart';
import 'package:hospital_app/domain/hospital_services.dart';

void main() {
  late Hospitalservice service;

  
  setUp(() {
    service = Hospitalservice(
      repository: FileRepository(
        patientsPath: 'test_data/patients_test.json',
        doctorsPath: 'test_data/doctors_test.json',
        appointmentsPath: 'test_data/appointments_test.json',
      ),
    );
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
    expect(p.name, equals('Alice'));
    expect(p.id.startsWith('P'), isTrue);
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
    expect(d.specialization, equals('Cardiology'));
    expect(d.id.startsWith('D'), isTrue);
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
      specialization: 'Surgery',
    );

    final dt = DateTime(2025, 11, 11, 10, 0);

    // First appointment should work
    final a1 = service.scheduleAppointment(
      patientId: p1.id,
      doctorId: d.id,
      dateTime: dt,
    );
    expect(a1, isNotNull);

    // Second appointment (same time, same doctor) should fail
    final a2 = service.scheduleAppointment(
      patientId: p2.id,
      doctorId: d.id,
      dateTime: dt,
    );
    expect(a2, isNull);
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
      specialization: 'Obstetrics',
    );

    final dt = DateTime(2025, 12, 12, 11, 0);

    final a1 = service.scheduleAppointment(
      patientId: p.id,
      doctorId: d1.id,
      dateTime: dt,
    );
    expect(a1, isNotNull);

    // Same patient, same time → should fail
    final a2 = service.scheduleAppointment(
      patientId: p.id,
      doctorId: d2.id,
      dateTime: dt,
    );
    expect(a2, isNull);
  });

  
  test('Reject appointment with unknown patient', () {
    final d = service.registerDoctor(
      name: 'Dr Y',
      age: 40,
      gender: 'M',
      phone: '07',
      specialization: 'Dermatology',
    );
    final dt = DateTime(2025, 9, 9, 8, 0);

    final appt = service.scheduleAppointment(
      patientId: 'P999999', // Not registered
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
      doctorId: 'D999999', // Not registered
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
      specialization: 'Cardiology',
    );

    final dt1 = DateTime(2025, 7, 7, 9, 0);
    final dt2 = DateTime(2025, 7, 7, 10, 0);

    service.scheduleAppointment(patientId: p.id, doctorId: d.id, dateTime: dt1);
    service.scheduleAppointment(patientId: p.id, doctorId: d.id, dateTime: dt2);

    expect(service.allAppointments.length, 2);
  });

  
  test('Cancel Appointment', () {
    final p = service.registerPatient(
      name: 'CancelP',
      age: 25,
      gender: 'M',
      phone: '0111',
      medicalRecordNo: 'MRN8',
    );
    final d = service.registerDoctor(
      name: 'CancelD',
      age: 55,
      gender: 'M',
      phone: '0222',
      specialization: 'Ortho',
    );

    final appt = service.scheduleAppointment(
      patientId: p.id,
      doctorId: d.id,
      dateTime: DateTime(2025, 6, 6, 9, 0),
    );

    expect(service.allAppointments.length, 1);
    final removed = service.cancelAppointment(appt!.id);
    expect(removed, isTrue);
    expect(service.allAppointments.isEmpty, isTrue);
  });

  
  test('Save and Load Data works', () async {
    // Register and save
    final p = service.registerPatient(
      name: 'SaveTest',
      age: 20,
      gender: 'M',
      phone: '0123',
      medicalRecordNo: 'MRN10',
    );
    await service.saveAll();

    // Create a new service and load
    final newService = Hospitalservice(
      repository: FileRepository(
        patientsPath: 'test_data/patients_test.json',
        doctorsPath: 'test_data/doctors_test.json',
        appointmentsPath: 'test_data/appointments_test.json',
      ),
    );
    await newService.loadAll();

    expect(newService.allPatients.length, greaterThanOrEqualTo(1));
    expect(newService.findPatientById(p.id)?.name, equals('SaveTest'));
  });
}
