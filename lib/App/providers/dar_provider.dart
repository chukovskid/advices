import 'package:flutter/material.dart';

import '../models/services/dogovorZaDar.dart';
import '../models/services/personalInfo.dart';

class DogovorZaDarProvider with ChangeNotifier {
  DogovorZaDar _dogovorZaDar =
      DogovorZaDar(applicant: null, daroprimac: null, daruvac: null);
  int _currentSection = 0;
  bool isApplicant = false;
  bool skipSection = false;

  final List<String> _sectionTitles = [
    'Applicant',
    'Daruvac',
    'Daroprimac',
    'Daruvac Polnomosnik',
    'Daroprimac Polnomosnik',
  ];

  DogovorZaDar get dogovorZaDar => _dogovorZaDar;
  int get currentSection => _currentSection;
  String get currentSectionTitle => _sectionTitles[_currentSection];

  void nextSection(PersonalInfo personalInfo) {
    switch (_currentSection) {
      case 0:
        _dogovorZaDar.applicant = personalInfo;
        break;
      case 1:
        _dogovorZaDar.daruvac = personalInfo;
        break;
      case 2:
        _dogovorZaDar.daroprimac = personalInfo;
        break;
      case 3:
        _dogovorZaDar.daruvacPolnomosnik = personalInfo;
        break;
      case 4:
        _dogovorZaDar.daroprimacPolnomosnik = personalInfo;
        break;
    }
    if (skipSection) _currentSection++;
    skipSection = false;
    _currentSection++;
    notifyListeners();
  }

  void submitForm() {
    print(_dogovorZaDar.toMap());
  }
}
