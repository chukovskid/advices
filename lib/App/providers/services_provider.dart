import 'package:advices/App/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';

import '../models/service.dart';
import '../models/user.dart';

class ServicesProvider with ChangeNotifier {
  final AuthProvider auth = AuthProvider();

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
  String selectedServiceId = "";

  submitForm() async {
    FlutterUser fUser = FlutterUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      surname: surnameController.text,
      phoneNumber: phoneController.text,
      lawField: selectedLawAreaName ?? "",
      description: descriptionController.text,
      experience: experienceController.text,
      yearsOfExperience: yearsOfExperienceController.text,
      education: educationController.text,
    );

    try {
      FlutterUser? createdUser =
          await auth.registerWithEmailAndPassword(fUser, selectedServices);
      // navigateToAuth();
    } catch (e) {
      print(e);
    }

    formKey.currentState?.save();
    formKey.currentState?.reset();
    // _nextFocus(_emailFocusNode);
  }

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

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  FocusNode get focusNode => _focusNode;
  TextEditingController get controller => _controller;
}
