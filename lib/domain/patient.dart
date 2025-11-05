
import "person.dart";


class Patient extends Person{

  final String medicalRecordNo;

  Patient({required super.id,required super.name,required super.age,required super.gender,required super.phone,required this.medicalRecordNo});

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


  factory Patient.fromJson(Map<String, dynamic> json){
    return Patient(id: json['id'], name: json['name'], age: json['age'], gender: json['gender'], phone: json['phone'], medicalRecordNo: json['medicalRecordNo'])
  }


  
}