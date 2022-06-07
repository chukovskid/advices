import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static setSensorPreference(int i) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("sensor", i.toString());
  }

  static getSensorPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("sensor");
  }

  static removeSensorPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString("sensor", "100");
  }

  static setStepsGoalPreference(String stepsGoal) async {
    var value = double.tryParse(stepsGoal);
    if (value != null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("goal", stepsGoal);
    }
  }

  static Future<double> getStepsGoalPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var value = preferences.getString("goal");
    if (value != null) {
      return double.parse(value);
    }
    ;
    return 5000;
  }

  static Future<bool> changeLanguagePreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? language = preferences.getBool("language");
    if (language == null) {
      language = true;
    }
    bool setLanguage = !language;
    preferences.setBool("language", setLanguage);
    return setLanguage ;
  }

  static Future<bool> getLanguagePreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? language = preferences.getBool("language");
    if (language == null) {
      language = true;
    }
    preferences.setBool("language", language);
    return language;
  }
}
