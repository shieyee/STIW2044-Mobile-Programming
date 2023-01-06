class User {
  String? name;
  String? email;
  String? phoneno;
  String? address;

  User(
      {required this.name,
      required this.email,
      required this.phoneno,
      required this.address, required String phone,});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneno = json['phoneno'];
    address = json['address'];
  }

  get id => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phoneno'] = phoneno;
    data['address'] = address;
    return data;
  }
}