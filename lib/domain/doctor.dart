
import 'person.dart';


class Doctor extends Person{

  final String specialization;
  Doctor({required super.id, required super.name, required super.age, required super.gender, required super.phone, required this.specialization});


}