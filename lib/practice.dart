class Person {
  String? name;
  int? age;
  String? sex;

  Person({String? name, int? age, String? sex}) {
    this.name = name;
    this.age = age;
    this.sex = sex;
  }
}

void main() {
  Person p1 = Person(age:38);
  Person p2 = Person(sex:'여성');
  print(p1.age);
  print(p2.sex);
}
