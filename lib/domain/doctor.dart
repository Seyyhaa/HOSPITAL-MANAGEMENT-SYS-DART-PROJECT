
import 'person.dart';


class Doctor extends Person{

  final String specialization;
  Doctor({required super.id, required super.name, required super.age, required super.gender, required super.phone, required this.specialization});


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'phone': phone,
      'spespecialization':specialization,
    };
  }
factory Doctor.fromJson(Map<String, dynamic> json){
    return Doctor(id: json['id'], name: json['name'], age: json['age'], gender: json['gender'], phone: json['phone'], specialization: json['specialization']);
  } 

}


