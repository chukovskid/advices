import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../App/models/services/personalInfo.dart';
import '../../App/providers/dar_provider.dart';

class PersonalInfoForm extends StatefulWidget {
  @override
  _PersonalInfoFormState createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  final _controller = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _embgController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _embgController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DogovorZaDarProvider>(context);

    return Scaffold(
      body: Form(
          key: _formKey,
          child: Column(children: [
            Text('${provider.currentSectionTitle} Information'),
            TextFormField(
              controller: _nameController,
              focusNode: _focusNode,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _surnameController,
              decoration: InputDecoration(labelText: 'Surname'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a surname';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _embgController,
              decoration: InputDecoration(labelText: 'EMBG'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter EMBG';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an address';
                }
                return null;
              },
            ),
            Row(
              children: [
                Text('Is the applicant the daruvac?'),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<DogovorZaDarProvider>(context, listen: false)
                        .isApplicant = true;
                    if (_formKey.currentState!.validate()) {
                      PersonalInfo personalInfo = PersonalInfo(
                          name: _nameController.text,
                          surname: _surnameController.text,
                          embg: _embgController.text,
                          address: _addressController.text);
                      Provider.of<DogovorZaDarProvider>(context, listen: false)
                          .nextSection(personalInfo);
                      _nameController.clear();
                      _surnameController.clear();
                      _embgController.clear();
                      _addressController.clear();
                    }
                  },
                  child: Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<DogovorZaDarProvider>(context, listen: false)
                        .isApplicant = false;
                  },
                  child: Text('No'),
                ),
              ],
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       if (_formKey.currentState!.validate()) {
            //         PersonalInfo personalInfo = PersonalInfo(
            //             name: _nameController.text,
            //             surname: _surnameController.text,
            //             embg: _embgController.text,
            //             address: _addressController.text);

            //         if (provider.currentSection > 4) {
            //           provider.submitForm();
            //           return;
            //         }

            //         provider.nextSection(personalInfo);
            //         _nameController.clear();
            //         _surnameController.clear();
            //         _embgController.clear();
            //         _addressController.clear();
            //       }
            //     },
            //     child: SizedBox())
          ])),
    );
  }
}
