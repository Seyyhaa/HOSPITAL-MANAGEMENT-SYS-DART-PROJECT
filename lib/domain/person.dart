abstract class Person {
  final String id;
  final String name;
  final int age;
  final String gender;
  String _phone;

  Person({required this.id,required this.name,required this.age,required this.gender,required String phone}): _phone=phone;


  // String get id => _id;
  // String get name => _name;
  // int get age => _age;
  // String get gender => _gender;
  String get phone => _phone;

  // set id (String value) => _id = value;
  // set name(String value) => _name = value;
  // set age(int value) => _age = value;
  // set gender(String value) => _gender = value;
  set phone(String value) => _phone = value;

  



}