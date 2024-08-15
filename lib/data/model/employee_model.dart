class Employee {
  String? id;
  String? name;
  String? phone;
  String? email;
  String? designation;

  Employee({this.id, this.name, this.phone, this.email, this.designation});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['designation'] = designation;
    return data;
  }
}