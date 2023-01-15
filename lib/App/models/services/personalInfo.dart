class PersonalInfo {
  String uid;
  String name;
  String surname;
  String embg;
  String address;
  Contractor  contractor;

  PersonalInfo({
    this.uid = "",
    this.name = "",
    this.surname = "",
    this.embg = "",
    this.address = "",
    this.contractor = Contractor.PERSONAL,
  });

    Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'surname': surname,
      'embg': embg,
      'address': address,
      'contractor': contractor.index,
    };
  }


  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      uid: json['uid'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      embg: json['embg'] as String,
      address: json['address'] as String,
      contractor: Contractor.values[json['contractor'] as int],
    );
  }

}

enum Contractor { PERSONAL, PROXY, PROXY_LAWYER }
