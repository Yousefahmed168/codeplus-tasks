class PatientModel {
  String? name;
  String? image;
  String? dob;
  String? email;
  String? phone;
  int? gender;
  String? bio;
  String? city;
  String? uid;

  PatientModel({
    this.name,
    this.image,
    this.dob,
    this.email,
    this.phone,
    this.bio,
    this.city,
    this.uid,
    this.gender,
  });

  PatientModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    dob = json['dob'];
    email = json['email'];
    phone = json['phone'];
    bio = json['bio'];
    city = json['city'];
    uid = json['uid'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['dob'] = dob;
    data['email'] = email;
    data['phone'] = phone;
    data['bio'] = bio;
    data['city'] = city;
    data['uid'] = uid;
    data['gender'] = gender;
    return data;
  }

  Map<String, dynamic> toUpdateData() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (image != null) data['image'] = image;
    if (dob != null) data['dob'] = dob;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (bio != null) data['bio'] = bio;
    if (city != null) data['city'] = city;
    if (gender != null) data['gender'] = gender;
    return data;
  }
}
