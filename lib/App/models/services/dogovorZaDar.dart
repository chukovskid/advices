import 'package:advices/App/models/services/personalInfo.dart';

class DogovorZaDar {
  PersonalInfo? applicant;
  PersonalInfo? daruvac;
  PersonalInfo? daroprimac;
  PersonalInfo? daruvacPolnomosnik;
  PersonalInfo? daroprimacPolnomosnik;

  DogovorZaDar({
    required this.applicant,
    required this.daruvac,
    required this.daroprimac,
    this.daruvacPolnomosnik,
    this.daroprimacPolnomosnik,
  });

  factory DogovorZaDar.fromJson(Map<String, dynamic> json) {
    return DogovorZaDar(
      applicant: PersonalInfo.fromJson(json['applicant']),
      daruvac: PersonalInfo.fromJson(json['daruvac']),
      daroprimac: PersonalInfo.fromJson(json['daroprimac']),
      daruvacPolnomosnik: PersonalInfo.fromJson(json['daruvacPolnomosnik']),
      daroprimacPolnomosnik: PersonalInfo.fromJson(json['daroprimacPolnomosnik']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'applicant': applicant?.toMap(),
      'daruvac': daruvac?.toMap(),
      'daroprimac': daroprimac?.toMap(),
      'daruvacPolnomosnik': daruvacPolnomosnik?.toMap(),
      'daroprimacPolnomosnik': daroprimacPolnomosnik?.toMap(),
    };
  }
}
