// bin/main.dart
import 'dart:io';
import 'package:hospital_app/domain/hospitalService.dart';
import '../data/file_repository.dart';



void main() async {
  // Initialize repository with default paths (creates /data files)
  final repo = FileRepository(
    patientsPath: '../../data/patient.json',
    doctorsPath: '../../data/doctor.json',
    appointmentsPath: '../../data/appointment.json',
  );

  final service = Hospitalservice(repository: repo);

  // Try load existing data (if any)
  await service.loadAll();

  while (true) {
    showMenu();
    stdout.write('Enter choice: ');
    final choice = stdin.readLineSync();

    if (choice == null) continue;
    if (!await handleMenuInput(choice.trim(), service)) break;
  }
}

void showMenu() {
  print('');
  print('=== Hospital Appointment System ===');
  print('1) Register Patient');
  print('2) Register Doctor');
  print('3) Schedule Appointment');
  print('4) View Patients');
  print('5) View Doctors');
  print('6) View Appointments');
  print('7) Cancel Appointment');
  print('8) Save & Exit');
  print('0) Exit without saving');
  print('===================================');
}

Future<bool> handleMenuInput(String choice, Hospitalservice service) async {
  switch (choice) {
    case '1':
      registerPatientUI(service);
      break;
    case '2':
      registerDoctorUI(service);
      break;
    case '3':
      scheduleAppointmentUI(service);
      break;
    case '4':
      viewPatientsUI(service);
      break;
    case '5':
      viewDoctorsUI(service);
      break;
    case '6':
      viewAppointmentsUI(service);
      break;
    case '7':
      cancelAppointmentUI(service);
      break;
    case '8':
      await service.saveAll();
      print('Data saved. Exiting.');
      return false;
    case '0':
      print('Exiting without saving.');
      return false;
    default:
      print('Invalid choice.');
  }
  return true;
}

void registerPatientUI(Hospitalservice service) {
  stdout.write('Name: ');
  final name = stdin.readLineSync() ?? '';

  stdout.write('Age: ');
  final ageInput = stdin.readLineSync() ?? '0';
  final age = int.tryParse(ageInput) ?? 0;

  stdout.write('Gender: ');
  final gender = stdin.readLineSync() ?? '';

  stdout.write('Phone: ');
  final phone = stdin.readLineSync() ?? '';

  stdout.write('Medical Record No: ');
  final mrn = stdin.readLineSync() ?? '';

  final p = service.registerPatient(
    name: name,
    age: age,
    gender: gender,
    phone: phone,
    medicalRecordNo: mrn,
  );
  print('Patient registered: ${p.id} - ${p.name}');
}

void registerDoctorUI(Hospitalservice service) {
  stdout.write('Name: ');
  final name = stdin.readLineSync() ?? '';

  stdout.write('Age: ');
  final ageInput = stdin.readLineSync() ?? '0';
  final age = int.tryParse(ageInput) ?? 0;

  stdout.write('Gender: ');
  final gender = stdin.readLineSync() ?? '';

  stdout.write('Phone: ');
  final phone = stdin.readLineSync() ?? '';

  stdout.write('Specialization: ');
  final spec = stdin.readLineSync() ?? '';

  final d = service.registerDoctor(
    name: name,
    age: age,
    gender: gender,
    phone: phone,
    specialization: spec,
  );
  print('Doctor registered: ${d.id} - ${d.name} (${d.specialization})');
}

void scheduleAppointmentUI(Hospitalservice service) {
  print('--- Schedule Appointment ---');

  // Show patients quick list
  print('Patients:');
  for (var p in service.allPatients) {
    print('${p.id} - ${p.name}');
  }
  stdout.write('Enter Patient ID: ');
  final pid = stdin.readLineSync() ?? '';

  // Show doctors quick list
  print('Doctors:');
  for (var d in service.allDoctors) {
    print('${d.id} - ${d.name} (${d.specialization})');
  }
  stdout.write('Enter Doctor ID: ');
  final did = stdin.readLineSync() ?? '';

  stdout.write('Enter Date (YYYY-MM-DD): ');
  final date = stdin.readLineSync() ?? '';

  stdout.write('Enter Time (HH:MM, 24h): ');
  final time = stdin.readLineSync() ?? '';

  try {
    final dt = DateTime.parse('$date $time');
    final appt = service.scheduleAppointment(
      patientId: pid,
      doctorId: did,
      dateTime: dt,
    );
    if (appt == null) {
      print('Failed to schedule - check IDs or availability.');
    } else {
      print('Appointment scheduled: ${appt.id} at ${appt.dateTime}');
    }
  } catch (e) {
    print('Invalid date/time format. Use YYYY-MM-DD and HH:MM.');
  }
}

void viewPatientsUI(Hospitalservice service) {
  print('--- Patients ---');
  for (var p in service.allPatients) {
    print('${p.id} | ${p.name} | ${p.age} | ${p.phone} | MRN:${p.medicalRecordNo}');
  }
}

void viewDoctorsUI(Hospitalservice service) {
  print('--- Doctors ---');
  for (var d in service.allDoctors) {
    print('${d.id} | ${d.name} | ${d.specialization} | ${d.phone}');
  }
}

void viewAppointmentsUI(Hospitalservice service) {
  print('--- Appointments ---');
  for (var a in service.allAppointments) {
    print('${a.id} | ${a.dateTime.toString()} | Patient: ${a.patient.name} (${a.patient.id}) | Doctor: ${a.doctor.name} (${a.doctor.id})');
  }
}

void cancelAppointmentUI(Hospitalservice service) {
  stdout.write('Enter Appointment ID to cancel: ');
  final id = stdin.readLineSync() ?? '';
  final ok = service.cancelAppointment(id);
  if (ok) {
    print('Appointment $id canceled.');
  } else {
    print('Appointment not found.');
  }
}
