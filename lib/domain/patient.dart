import "person.dart";

class Patient extends Person {
  final String medicalRecordNo;

  Patient(
      {required super.id,
      required super.name,
      required super.age,
      required super.gender,
      required super.phone,
      required this.medicalRecordNo}) {
    if (medicalRecordNo.trim().isEmpty) {
      throw ArgumentError('Medical record number cannot be empty.');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'phone': phone,
      'medicalRecordNo': medicalRecordNo,
    };
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        gender: json['gender'],
        phone: json['phone'],
        medicalRecordNo: json['medicalRecordNo']);
  }
}
