abstract class Person {
  final String id;
  final String name;
  final int age;
  final String gender;
  String _phone;

  Person(
      {required this.id,
      required this.name,
      required this.age,
      required this.gender,
      required String phone})
      : _phone = phone {
    if (name.trim().isEmpty) {
      throw ArgumentError('Name cannot be empty!.');
    }
    if (phone.trim().isEmpty) {
      throw ArgumentError('Phone cannot be empty!.');
    }
    if (age <= 0 && age >= 140) {
      throw ArgumentError('Age must be a positive number.');
    }
  }

  String get phone => _phone;
  set phone(String value) => _phone = value;
}
