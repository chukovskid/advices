import 'package:flutter/material.dart';

import '../models/services/contract.dart';
import '../models/services/question.dart';

class FormBuilderProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  List<Contract> contracts = [
    Contract(id: 1, name: 'Contract 1', questions: [])
  ];
  late String? _tempTitle;
  List<String> _tempOptions = [];

  void addQuestion(BuildContext context, QuestionType type,
      {int? index,
      String? currentTitle,
      List<String>? currentOptions,
      String? currentDescription}) async {
    if (type == QuestionType.text) {
      _tempTitle = await _askQuestionTitle(context, currentTitle);
    } else if (type == QuestionType.sectionDescription) {
      final result = await _askSectionTitleAndDescription(
          context, currentTitle, currentDescription);
      _tempTitle = result[0];
      String temp = result[1];
      _tempOptions = [temp];
    } else {
      final result = await _askQuestionTitleAndOptions(
          context, currentTitle, currentOptions ?? []);
      _tempTitle = result[0];
      _tempOptions = result[1];
    }
    if (index != null) {
      // Updating existing question
      contracts.last.questions[index] = Question(
          type: type, questionText: _tempTitle ?? '', options: _tempOptions);
    } else {
      // Adding new question
      contracts.last.questions.add(Question(
          type: type, questionText: _tempTitle ?? '', options: _tempOptions));
    }
    notifyListeners();
  }

  Future<String?> _askQuestionTitle(
      BuildContext context, String? currentTitle) async {
    String? title = currentTitle;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter question title"),
          content: TextFormField(
            initialValue: currentTitle,
            onChanged: (value) => title = value,
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () => {Navigator.pop(context, title)},
            ),
          ],
        );
      },
    );
    return title;
  }

  Future<List> _askQuestionTitleAndOptions(BuildContext context,
      String? currentTitle, List<String> currentOptions) async {
    List<OptionField> optionFields =
        currentOptions.map((e) => OptionField(initialValue: e)).toList();
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter question title"),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: currentTitle,
                  onChanged: (value) => _tempTitle = value,
                ),
                Center(
                  child: Column(
                    children: optionFields
                        .map((optionField) =>  Column(
                              children: [
                                TextFormField(
                                  initialValue: optionField._tempOption,
                                  decoration: InputDecoration(
                                      labelText:
                                          'Option ${optionFields.indexOf(optionField) + 1}'),
                                  onChanged: (value) {
                                    optionField.onChanged(value);
                                  },
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(labelText: 'Скокни прашања'),
                                  onChanged: (value) {
                                    optionField.onChanged(value);
                                  },
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                ),
                ElevatedButton(
                  child: Text("Add option"),
                  onPressed: () {
                    setState(() {
                      optionFields.add(OptionField(initialValue: ''));
                    });
                  },
                )
              ],
            );
          }),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context, [
                _tempTitle,
                optionFields.map((e) => e._tempOption).toList()
              ]),
            ),
          ],
        );
      },
    );
  }

  Future<List> _askSectionTitleAndDescription(BuildContext context,
      String? currentTitle, String? currentDescription) async {
    String? title = currentTitle;
    String? description = currentDescription;
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter section title and description"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: currentTitle,
                onChanged: (value) => title = value,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                initialValue: currentDescription,
                onChanged: (value) => description = value,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context, [title, description]),
            ),
          ],
        );
      },
    );
  }

  void editQuestion(BuildContext context, int index) async {
    final question = contracts.last.questions[index];
    if (question.type == QuestionType.text) {
      addQuestion(context, QuestionType.text,
          index: index, currentTitle: question.questionText);
    } else if (question.type == QuestionType.sectionDescription) {
      addQuestion(context, QuestionType.sectionDescription,
          index: index,
          currentTitle: question.questionText,
          currentDescription: question.options?[0]);
    } else {
      addQuestion(context, question.type,
          index: index,
          currentTitle: question.questionText,
          currentOptions: question.options);
    }
  }

  void moveQuestionUp(int index) {
    if (index > 0) {
      final question = contracts.last.questions.removeAt(index);
      contracts.last.questions.insert(index - 1, question);
      notifyListeners();
    }
  }

  void moveQuestionDown(int index) {
    if (index < contracts.last.questions.length - 1) {
      final question = contracts.last.questions.removeAt(index);
      contracts.last.questions.insert(index + 1, question);
      notifyListeners();
    }
  }

  submitFormBuilder() {
    print(contracts.last.questions.last.questionText);
  }
}

class OptionField {
  late String _tempOption;

  OptionField({required String initialValue}) {
    _tempOption = initialValue;
  }

  void onChanged(String value) {
    _tempOption = value;
  }
}
