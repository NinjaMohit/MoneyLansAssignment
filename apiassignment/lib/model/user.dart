class User {
  final String id;
  final String name;
  final String atype;
  int? age;
  String? gender;

  User({
    required this.id,
    required this.name,
    required this.atype,
    this.age,
    this.gender,
  });
}
