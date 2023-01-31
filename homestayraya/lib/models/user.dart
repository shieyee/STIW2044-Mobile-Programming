class User {
  String? id;
   String? email;
  String? name;
  String? contactno;
  String? regdate;
  // String? otp;
  String? address;
  // String? credit;

  User(
      {required this.id,
      required this.email,
      required this.name,
      required this.contactno,
      required this.regdate,
      // required this.otp,
      required this.address});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    contactno = json['contactno'];
    regdate = json['regdate'];
    // otp = json['otp'];
    address = json['address'];
    // credit = json['credit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['contactno'] = contactno;
    data['regdate'] = regdate;
    // data['otp'] = otp;
    data['address'] = address;
    // data['credit'] = credit;
    return data;
  }
}