import 'dart:convert';
import 'dart:io';

class FileRepository {
  final String patientsPath;
  final String doctorsPath;
  final String appointmentsPath;

  FileRepository({
    this.patientsPath = './data/patient.json',
    this.doctorsPath = './data/doctor.json',
    this.appointmentsPath = './data/assets/appointment.json',
  });

  void _ensureFolderExists(String path) {
    final dir = Directory(path).parent;
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  Future<void> savePatients(List<Map<String, dynamic>> patients) async {
    _ensureFolderExists(patientsPath);
    final file = File(patientsPath);
    await file.writeAsString(jsonEncode(patients), flush: true);
  }

  Future<List<dynamic>> loadPatients() async {
    final file = File(patientsPath);
    if (!file.existsSync()) return [];
    final content = await file.readAsString();
    return jsonDecode(content) as List<dynamic>;
  }

  Future<void> saveDoctors(List<Map<String, dynamic>> doctors) async {
    _ensureFolderExists(doctorsPath);
    final file = File(doctorsPath);
    await file.writeAsString(jsonEncode(doctors), flush: true);
  }

  Future<List<dynamic>> loadDoctors() async {
    final file = File(doctorsPath);
    if (!file.existsSync()) return [];
    final content = await file.readAsString();
    return jsonDecode(content) as List<dynamic>;
  }

  Future<void> saveAppointments(List<Map<String, dynamic>> appointments) async {
    _ensureFolderExists(appointmentsPath);
    final file = File(appointmentsPath);
    await file.writeAsString(jsonEncode(appointments), flush: true);
  }

  Future<List<dynamic>> loadAppointments() async {
    final file = File(appointmentsPath);
    if (!file.existsSync()) return [];
    final content = await file.readAsString();
    return jsonDecode(content) as List<dynamic>;
  }
}
