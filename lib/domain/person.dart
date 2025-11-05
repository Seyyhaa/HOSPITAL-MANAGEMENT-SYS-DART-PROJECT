abstract class Person {
  final String id;
  final String name;
  final int age;
  final String gender;
  String _phone;

  Person({required this.id,required this.name,required this.age,required this.gender,required String phone}): _phone=phone;


  String get phone => _phone;

  set phone(String value) => _phone = value;

  

}