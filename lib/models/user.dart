class FlutterUser {
     String uid;
    String email;
    String password;
    String displayName;
    String name;
    String surname;
    String phoneNumber;
    bool isLawyer;
    String lawyerId;
    String description;
    String experience;
    String yearsOfExperience;
     String education;
    String lawField;
    String photoURL;
    double minPriceEuro;
    

  FlutterUser({
    this.uid = "",
    this.email= "",
    this.displayName= "",
    this.password= "",
    this.name= "",
    this.surname= "",
    this.phoneNumber= "",
    this.isLawyer= false,
    this.lawyerId= "",
    this.lawField= "",
    this.education= "",
    this.yearsOfExperience= "",
    this.experience= "",
    this.description= "",
    this.photoURL= "",
    this.minPriceEuro= 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'password': password,
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber,
      'lawyerId': lawyerId,
      'isLawyer': isLawyer,
      'description': description,
      'experience': experience,
      'yearsOfExperience': yearsOfExperience,
      'education': education,
      'lawField': lawField,
      'photoURL': photoURL,
      'minPriceEuro': minPriceEuro,
    };
  }

  // FlutterUser.fromJson(json)
  //   : this(
  //     uid:json['uid']! as String,
  //     email:json['email']! as String,
  //     displayName:json['displayName']! as String,
  //     password:json['password']! as String,
  //     name:json['name']! as String,
  //     surname:json['surname']! as String,
  //     phoneNumber:json['phoneNumber']! as String,
  //     lawyerId:json['lawyerId']! as String,
  //     isLawyer:json['isLawyer']! as bool,
  //     description:json['description']! as String,
  //     experience:json['experience']! as String,
  //     yearsOfExperience:json['yearsOfExperience']! as String,
  //     education:json['education']! as String,
  //     lawField:json['lawField']! as String,
  //     photoURL:json['photoURL']! as String,
  //     );

  static FlutterUser fromJson(json) => FlutterUser(
        uid: json['uid'] as String ? ?? "",
        email: json['email'] as String ? ?? "",
        displayName: json['displayName'] as String ? ?? "",
        name: json['name'] as String ? ?? "",
        surname: json['surname'] as String ? ?? "",
        phoneNumber: json['phoneNumber'] as String ? ?? "",
        lawyerId: json['lawyerId'] as String ? ?? "",
        isLawyer: json['isLawyer'] as bool ? ?? false,
        description: json['description'] as String ? ?? "",
        experience: json['experience'] as String ? ?? "",
        yearsOfExperience: json['yearsOfExperience'] as String ? ?? "",
        education: json['education'] as String ? ?? "",
        lawField: json['lawField'] as String ? ?? "",
        photoURL: json['photoURL'] as String ? ?? "",
        minPriceEuro: json['minPriceEuro'] as double? ?? 1,
      );
}
