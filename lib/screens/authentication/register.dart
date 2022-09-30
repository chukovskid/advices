// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:advices/models/service.dart';
import 'package:advices/screens/home.dart';
import 'package:advices/services/database.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../models/service.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../../utilities/constants.dart';
import '../shared_widgets/base_app_bar.dart';
import 'authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _surnameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _lawFieldFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _experienceFocusNode = FocusNode();
  final FocusNode _yearsOfExperienceFocusNode = FocusNode();
  final FocusNode _educationFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _yearsOfExperienceController =
      TextEditingController();
  final TextEditingController _educationController = TextEditingController();

  bool? isLawyer = null;
  String registerAsText = '';
  bool _openLawyerInputs = false;
  String password = '';
  FlutterUser? user;
  List<Service?> selectedServices = [];
  var selectedLawAreaName;
  var carMake, carMakeModel;
  var setDefaultMake = true, setDefaultMakeModel = true;
  bool showSelectService = false;

  _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    var isLawyerConst = false;
    isLawyerConst = isLawyer ?? false;
    if (isValid) {
      FlutterUser fUser = FlutterUser(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        surname: _surnameController.text,
        phoneNumber: _phoneController.text,
        isLawyer: isLawyerConst,
        lawField: selectedLawAreaName,
        description: _descriptionController.text,
        experience: _experienceController.text,
        yearsOfExperience: _yearsOfExperienceController.text,
        education: _educationController.text,
      );

      try {
        FlutterUser? createdUser =
            await _auth.registerWithEmailAndPassword(fUser, selectedServices);
        _navigateToAuth();
      } catch (e) {
        print(e);
      }

      // If the form passes validation, display a Snackbar.
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: const Text('Registration sent')));

      _formKey.currentState?.save();
      _formKey.currentState?.reset();
      _nextFocus(_emailFocusNode);
    }
  }

  String? _validateInput(String value) {
    if (value.trim().isEmpty) {
      return 'Field required';
    }
    return null;
  }

  void goBack() {
    Navigator.pop(context);
  }

  _navigateToAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authenticate()),
    );
  }

  _navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),

      // backgroundColor: const Color.fromARGB(255, 226, 146, 100),
      body: Container(
          height: double.maxFinite,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: backgroundColor,
              stops: [-1, 2],
            ),
          ),
          child: _allUsersForm() // _selectLawArea(), // _allUsersForm(),
          // child: _dropdownLawSelect(),
          ),
    );
  }

  Widget _allUsersForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          // height: 60,
          margin: const EdgeInsets.all(35),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Register",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              Text(
                registerAsText,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 35.0),
              isLawyer == null ? _isLawyerBool() : const SizedBox(),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(height: 20.0),
              isLawyer != null
                  ? (_openLawyerInputs
                      ? (showSelectService == false
                          ? _showLawyerRegisterFields()
                          : _dropdownLawSelect())
                      : _showRegisterFields())
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _isLawyerBool() {
    return Column(
      children: [
        const Text(
          "Are you a client or a lawyer?",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center, //Center Row contents horizontally,
          children: [
            Column(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue)),
                      // textColor: const Color.fromARGB(255, 9, 123, 161),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: new BorderRadius.circular(40.0),
                      // ),
                      // color: const Color.fromARGB(255, 255, 255, 255),
                      child: const Center(
                          child: FaIcon(
                        FontAwesomeIcons.user,
                        semanticLabel: "label",
                      )),
                      onPressed: () async {
                        setState(() {
                          isLawyer = false;
                          registerAsText = "client";
                        });
                      }),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Client",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            const SizedBox(width: 25.0),
            Column(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue)),

                      // textColor: const Color.fromARGB(255, 161, 113, 9),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: new BorderRadius.circular(40.0),
                      // ),
                      // color: const Color.fromARGB(255, 255, 255, 255),
                      child: const Center(
                          child: FaIcon(
                        FontAwesomeIcons.gavel,
                        semanticLabel: "label",
                      )),
                      onPressed: () async {
                        setState(() {
                          isLawyer = true;
                          registerAsText = "lawyer";
                        });
                      }),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Lawyer",
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _showRegisterFields() {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          focusNode: _emailFocusNode,
          onFieldSubmitted: (String value) {
            //Do anything with value
            _nextFocus(_passwordFocusNode);
          },
          controller: _emailController,
          validator: (value) => _validateInput(value!),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              errorStyle: TextStyle(
                color: Color.fromRGBO(225, 103, 104, 1),
              ),
              fillColor: Colors.orange,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(225, 103, 104, 1)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              labelText: "Email",
              labelStyle: TextStyle(
                color: Color.fromARGB(209, 255, 255, 255),
              )),
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          focusNode: _passwordFocusNode,
          onFieldSubmitted: (String value) {
            _nextFocus(_nameFocusNode);
          },
          controller: _passwordController,
          validator: (value) => _validateInput(value!),
          style: const TextStyle(color: Colors.white),
          obscureText: true,
          decoration: const InputDecoration(
              errorStyle: TextStyle(
                color: Color.fromRGBO(225, 103, 104, 1),
              ),
              fillColor: Colors.orange,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(225, 103, 104, 1)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              labelText: "Password",
              labelStyle: TextStyle(
                color: Color.fromARGB(209, 255, 255, 255),
              )),
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          focusNode: _nameFocusNode,
          onFieldSubmitted: (String value) {
            _nextFocus(_surnameFocusNode);
          },
          controller: _nameController,
          validator: (value) => _validateInput(value!),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              errorStyle: TextStyle(
                color: Color.fromRGBO(225, 103, 104, 1),
              ),
              fillColor: Colors.orange,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(225, 103, 104, 1)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              labelText: "Name",
              labelStyle: TextStyle(
                color: Color.fromARGB(209, 255, 255, 255),
              )),
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          focusNode: _surnameFocusNode,
          onFieldSubmitted: (String value) {
            _nextFocus(_phoneFocusNode);
          },
          controller: _surnameController,
          validator: (value) => _validateInput(value!),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              errorStyle: TextStyle(
                color: Color.fromRGBO(225, 103, 104, 1),
              ),
              fillColor: Colors.orange,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(225, 103, 104, 1)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              labelText: "Surname",
              labelStyle: TextStyle(
                color: Color.fromARGB(209, 255, 255, 255),
              )),
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          focusNode: _phoneFocusNode,
          onFieldSubmitted: (String value) async {
            if (isLawyer == false) {
              await _submitForm();
            } else if (isLawyer == true) {
              setState(() {
                _openLawyerInputs = true;
              });
            }
          },
          controller: _phoneController,
          validator: (value) => _validateInput(value!),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              errorStyle: TextStyle(
                color: Color.fromRGBO(225, 103, 104, 1),
              ),
              fillColor: Colors.orange,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(225, 103, 104, 1)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              labelText: "Phone",
              labelStyle: TextStyle(
                color: Color.fromARGB(209, 255, 255, 255),
              )),
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(225, 103, 104, 1))),

            // color: const Color.fromRGBO(225, 103, 104, 1),
            child: Text(
              '${isLawyer == false ? "Submit form" : "Next"}',
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              //  if (_formKey.currentState.validate()) {
              //     // If the form is valid, display a snackbar. In the real world,
              //     // you'd often call a server or save the information in a database.
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text('Processing Data')),
              //     );
              //   }

              if (isLawyer == false) {
                await _submitForm();
              } else if (isLawyer == true) {
                setState(() {
                  final isValid = _formKey.currentState!.validate();
                  if (isValid) {
                    _openLawyerInputs = true;
                  }
                });
              }
            })
      ]),
    );
  }

  Widget _showLawyerRegisterFields() {
    return SingleChildScrollView(
      child: Expanded(
        child: Column(children: <Widget>[
          // TextFormField(
          //   keyboardType: TextInputType.text,
          //   textInputAction: TextInputAction.next,
          //   focusNode: _lawFieldFocusNode,
          //   onFieldSubmitted: (String value) {
          //     //Do anything with value
          //     _nextFocus(_descriptionFocusNode);
          //   },
          //   controller: _lawFieldController,
          //   validator: (value) => _validateInput(value!),
          //   style: const TextStyle(color: Colors.white),
          //   decoration: const InputDecoration(
          //       errorStyle: TextStyle(
          //         color: Color.fromRGBO(225, 103, 104, 1),
          //       ),
          //       fillColor: Colors.orange,
          //       enabledBorder: UnderlineInputBorder(
          //         borderSide:
          //             BorderSide(color: Color.fromRGBO(225, 103, 104, 1)),
          //       ),
          //       focusedBorder: UnderlineInputBorder(
          //         borderSide:
          //             BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
          //       ),
          //       labelText: "Law field",
          //       labelStyle: TextStyle(
          //         color: Color.fromARGB(209, 255, 255, 255),
          //       )),
          // ),

          // const SizedBox(height: 20.0),
          TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            focusNode: _descriptionFocusNode,
            onFieldSubmitted: (String value) {
              _nextFocus(_experienceFocusNode);
            },
            controller: _descriptionController,
            validator: (value) => _validateInput(value!),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                errorStyle: TextStyle(
                  color: Color.fromRGBO(225, 103, 104, 1),
                ),
                fillColor: Colors.orange,
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(225, 103, 104, 1)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                labelText: "Description",
                labelStyle: TextStyle(
                  color: Color.fromARGB(209, 255, 255, 255),
                )),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            focusNode: _experienceFocusNode,
            onFieldSubmitted: (String value) {
              _nextFocus(_yearsOfExperienceFocusNode);
            },
            controller: _experienceController,
            validator: (value) => _validateInput(value!),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                errorStyle: TextStyle(
                  color: Color.fromRGBO(225, 103, 104, 1),
                ),
                fillColor: Colors.orange,
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(225, 103, 104, 1)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                labelText: "Experience",
                labelStyle: TextStyle(
                  color: Color.fromARGB(209, 255, 255, 255),
                )),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            focusNode: _yearsOfExperienceFocusNode,
            onFieldSubmitted: (String value) {
              _nextFocus(_educationFocusNode);
            },
            controller: _yearsOfExperienceController,
            validator: (value) => _validateInput(value!),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                errorStyle: TextStyle(
                  color: Color.fromRGBO(225, 103, 104, 1),
                ),
                fillColor: Colors.orange,
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(225, 103, 104, 1)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                labelText: "Years of experience",
                labelStyle: TextStyle(
                  color: Color.fromARGB(209, 255, 255, 255),
                )),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            focusNode: _educationFocusNode,
            onFieldSubmitted: (String value) async {
              setState(() {
                showSelectService = true;
              });
            },
            controller: _educationController,
            validator: (value) => _validateInput(value!),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                errorStyle: TextStyle(
                  color: Color.fromRGBO(225, 103, 104, 1),
                ),
                fillColor: Colors.orange,
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(225, 103, 104, 1)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                labelText: "Education",
                labelStyle: TextStyle(
                  color: Color.fromARGB(209, 255, 255, 255),
                )),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(orangeColor)),

              // color: orangeColor,
              child: Text(
                '$registerAsText',
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                setState(() {
                  showSelectService = true;
                });
              })
        ]),
      ),
    );
  }

  Widget _dropdownLawSelect() {
    return Column(
      children: [
        DropdownButtonHideUnderline(
            child: StreamBuilder<Iterable<Service>>(
                stream: DatabaseService.getAllServices(),
                builder: (context, snapshot) {
                  // Safety check to ensure that snapshot contains data
                  // without this safety check, StreamBuilder dirty state warnings will be thrown
                  if (!snapshot.hasData) return Container();
                  // Set this value for default,
                  // setDefault will change if an item was selected
                  // First item from the List will be displayed
                  if (setDefaultMake) {
                    selectedLawAreaName = snapshot.data?.first.name;
                  }
                  final laws = snapshot.data!;

                  return Container(
                      // height: 100,
                      child: Column(
                    children: <Widget>[
                      MultiSelectDialogField(
                        dialogWidth: MediaQuery.of(context).size.width * 0.7,
                        decoration: const BoxDecoration(
                          // color: Colors.white,
                          border: Border(
                              // width: 2,
                              bottom: BorderSide(color: orangeColor)),
                        ),
                        listType: MultiSelectListType.LIST,
                        searchable: true,
                        buttonText: const Text(
                          "Select laws",
                          style: TextStyle(color: Colors.white),
                        ),
                        title: const Text("Права"),
                        // initialValue: selectedServices
                        //     .map((e) => MultiSelectItem(e, e!.index.toString()))
                        //     .toList(),
                        validator: (values) {
                          if (values == null || values.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        initialValue: [],
                        items: laws
                            .map((e) => MultiSelectItem(e, e.name))
                            .toList(),
                        onConfirm: (values) {
                          selectedServices.remove(values);
                          selectedServices.clear();
                          print(selectedServices);
                          for (int i = 0; i < values.length; i++) {
                            var val = values[i];
                            Service selectedService = Service.fromJson(
                                jsonDecode(values[i].toString()));
                            selectedServices.add(selectedService);
                          }
                          print(selectedServices);
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          items: selectedServices
                              .map((e) => MultiSelectItem(e, e!.name))
                              .toList(),
                          onTap: (value) {
                            setState(() {
                              selectedServices.remove(value);
                              selectedServices.clear();
                            });
                            return selectedServices;
                          },
                        ),
                      ),
                    ],
                  ));
                })),
        const SizedBox(
          height: 100,
        ),
        ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(orangeColor)),
            // color: orangeColor,
            child: const Text(
              'Submit2',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              print("hey");

              setState(() {
                // DatabaseService.saveLawAreasForLawyer("uid", selectedServices);
                _submitForm();
              });
            })
      ],
    );
  }
}
