import 'package:flutter/cupertino.dart';

import '../contexts/authContext.dart';
import '../models/service.dart';
import '../models/user.dart';

class ServicesProvider with ChangeNotifier {
  final AuthContext auth = AuthContext();
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode surnameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode lawFieldFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode experienceFocusNode = FocusNode();
  final FocusNode yearsOfExperienceFocusNode = FocusNode();
  final FocusNode educationFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController yearsOfExperienceController =
      TextEditingController();
  final TextEditingController educationController = TextEditingController();

  bool? isLawyer = null;
  String registerAsText = '';
  bool openLawyerInputs = false;
  String password = '';
  FlutterUser? user;
  List<Service?> selectedServices = [];
  var selectedLawAreaName;
  var carMake, carMakeModel;
  var setDefaultMake = true, setDefaultMakeModel = true;
  bool showSelectService = false;

  // ... Add the _nextFocus, _submitForm, and _validateInput methods here

  // submitForm() async {
  //   // final isValid = formKey.currentState!.validate();
  //   // var isLawyerConst = false;
  //   // isLawyerConst = isLawyer ?? false;
  //   // if (isValid) {
  //   FlutterUser fUser = FlutterUser(
  //     email: emailController.text,
  //     password: passwordController.text,
  //     name: nameController.text,
  //     surname: surnameController.text,
  //     phoneNumber: phoneController.text,
  //     // isLawyer: isLawyerConst,
  //     lawField: selectedLawAreaName ?? "",
  //     description: descriptionController.text,
  //     experience: experienceController.text,
  //     yearsOfExperience: yearsOfExperienceController.text,
  //     education: educationController.text,
  //   );

  //   try {
  //     FlutterUser? createdUser =
  //         await auth.registerWithEmailAndPassword(fUser, selectedServices);
  //     // navigateToAuth();
  //   } catch (e) {
  //     print(e);
  //   }

  //   // // If the form passes validation, display a Snackbar.
  //   // ScaffoldMessenger.of(context).showSnackBar(
  //   //     const SnackBar(content: const Text('Registration sent')));

  //   formKey.currentState?.save();
  //   formKey.currentState?.reset();
  //   // _nextFocus(_emailFocusNode);
  // }

  String? validateInput(String value) {
  if (value.trim().isEmpty) {
    return 'Field required';
  }
  return null;
}






final formKey = GlobalKey<FormState>();
  final textController1 = TextEditingController();
  final textController2 = TextEditingController();
  final textController3 = TextEditingController();

  void submitForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      print("Text 1: ${textController1.text}");
      print("Text 2: ${textController2.text}");
      print("Text 3: ${textController3.text}");
    }
  }


















}


