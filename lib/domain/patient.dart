
import "person.dart";


class Patient extends Person{

  final String medicalRecordNo;

  Patient({required super.id,required super.name,required super.age,required super.gender,required super.phone,required this.medicalRecordNo});

}