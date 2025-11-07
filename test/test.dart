import 'package:test/test.dart';
import 'package:hospital_app/domain/hospital_services.dart';
import 'package:hospital_app/domain/patient.dart';
import 'package:hospital_app/domain/doctor.dart';

void main() {
  late Hospitalservice service;
  late Patient patient1, patient2;
  late Doctor doctor1, doctor2;


  setUp(() {
    service = Hospitalservice();

    doctor1 = service.registerDoctor(
      name: 'Dr Ronan',
      age: 30,
      gender: 'M',
      phone: '0101010101',
      specialization: 'Cardiology',
    );

    doctor2 = service.registerDoctor(
      name: 'Dr The Best',
      age: 28,
      gender: 'F',
      phone: '0202020202',
      specialization: 'Dermatology',
    );

    patient1 = service.registerPatient(
      name: 'SOK SAN',
      age: 22,
      gender: 'M',
      phone: '0303030303',
      medicalRecordNo: 'MRN001',
    );

    patient2 = service.registerPatient(
      name: 'Davin',
      age: 25,
      gender: 'F',
      phone: '0404040404',
      medicalRecordNo: 'MRN002',
    );
  });


  test('Register Patient', () {
    expect(service.allPatients.length, equals(2));
    expect(patient1.id.startsWith('P'), isTrue);
    expect(patient2.name, equals('Davin'));
  });


  test('Register Doctor', () {
    expect(service.allDoctors.length, equals(2));
    expect(doctor1.id.startsWith('D'), isTrue);
    expect(doctor1.specialization, equals('Cardiology'));
  });


  test('Schedule Appointment (successful)', () {
    final appt = service.scheduleAppointment(
      patientId: patient1.id,
      doctorId: doctor1.id,
      dateTime: DateTime(2025, 11, 10, 9, 0),
    );

    expect(appt, isNotNull);
    expect(service.allAppointments.length, equals(1));
  });


  test('Prevent Doctor Double Booking', () {
    final dt = DateTime(2025, 11, 11, 9, 0);
    final a1 = service.scheduleAppointment(
      patientId: patient1.id,
      doctorId: doctor1.id,
      dateTime: dt,
    );
    expect(a1, isNotNull);

    final a2 = service.scheduleAppointment(
      patientId: patient2.id,
      doctorId: doctor1.id,
      dateTime: dt,
    );
    expect(a2, isNull);
  });


  test('Prevent Patient Double Booking', () {
    final dt = DateTime(2025, 11, 12, 9, 0);
    final a1 = service.scheduleAppointment(
      patientId: patient1.id,
      doctorId: doctor1.id,
      dateTime: dt,
    );
    expect(a1, isNotNull);

    final a2 = service.scheduleAppointment(
      patientId: patient1.id,
      doctorId: doctor2.id,
      dateTime: dt,
    );
    expect(a2, isNull);
  });


  test('Reject Appointment with Unknown Patient', () {
    final appt = service.scheduleAppointment(
      patientId: 'P999',
      doctorId: doctor1.id,
      dateTime: DateTime(2025, 11, 13, 10, 0),
    );
    expect(appt, isNull);
  });


  test('Reject Appointment with Unknown Doctor', () {
    final appt = service.scheduleAppointment(
      patientId: patient1.id,
      doctorId: 'D999',
      dateTime: DateTime(2025, 11, 13, 10, 0),
    );
    expect(appt, isNull);
  });


  test('List Appointments', () {
    final dt1 = DateTime(2025, 11, 14, 9, 0);
    final dt2 = DateTime(2025, 11, 14, 10, 0);
    service.scheduleAppointment(patientId: patient1.id, doctorId: doctor1.id, dateTime: dt1);
    service.scheduleAppointment(patientId: patient2.id, doctorId: doctor2.id, dateTime: dt2);

    expect(service.allAppointments.length, equals(2));
  });


  test('Cancel Appointment', () {
    final appt = service.scheduleAppointment(
      patientId: patient1.id,
      doctorId: doctor1.id,
      dateTime: DateTime(2025, 11, 15, 9, 0),
    );

    final removed = service.cancelAppointment(appt!.id);
    expect(removed, isTrue);
    expect(service.allAppointments.isEmpty, isTrue);
  });


  test('Mock Save & Load Data', () async {
    final before = service.allPatients.length;

    final reloadedService = Hospitalservice();
    for (final p in service.allPatients) {
      reloadedService.registerPatient(
        name: p.name,
        age: p.age,
        gender: p.gender,
        phone: p.phone,
        medicalRecordNo: p.medicalRecordNo,
      );
    }

    expect(reloadedService.allPatients.length, equals(before));
  });
}
