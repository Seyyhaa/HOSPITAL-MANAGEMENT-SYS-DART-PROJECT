import 'dart:io';
import 'package:hospital_app/domain/hospital_services.dart';
import 'package:hospital_app/ui/hospital_ui.dart';
import './data/file_repository.dart';

void main() async {
  
  final repo = FileRepository(
    patientsPath: './data/patient.json',
    doctorsPath: './data/doctor.json',
    appointmentsPath: './data/appointment.json',
  );

  final service = Hospitalservice(repository: repo);

  await service.loadAll();

  while (true) {
    showMenu();
    stdout.write('Enter choice: ');
    final choice = stdin.readLineSync();

    if (choice == null) continue;
    if (!await handleMenuInput(choice.trim(), service)) break;
  }
}