import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../App/models/services/question.dart';
import '../../App/providers/form_builder_provider.dart';

class FormBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formBuilderProvider = Provider.of<FormBuilderProvider>(context);
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.text_fields),
                        title: Text('Text Input'),
                        onTap: () {
                          Navigator.pop(context);
                          formBuilderProvider.addQuestion(
                              context, QuestionType.text);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.list),
                        title: Text('Dropdown Input'),
                        onTap: () {
                          Navigator.pop(context);
                          formBuilderProvider.addQuestion(
                              context, QuestionType.dropdown);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.check_box),
                        title: Text('Checkbox Input'),
                        onTap: () {
                          Navigator.pop(context);
                          formBuilderProvider.addQuestion(
                              context, QuestionType.checkbox);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.description),
                        title: Text('Section Description'),
                        onTap: () {
                          Navigator.pop(context);
                          formBuilderProvider.addQuestion(
                              context, QuestionType.sectionDescription);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              formBuilderProvider.submitFormBuilder();
            },
            child: Icon(Icons.print),
          ),
        ],
      ),
      body: Form(
        key: formBuilderProvider.formKey,
        child: ListView.builder(
          itemCount: formBuilderProvider.contracts.last.questions.length,
          itemBuilder: (context, index) {
            final question =
                formBuilderProvider.contracts.last.questions[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  question.type == QuestionType.text
                      ? TextFormField(
                          decoration: InputDecoration(
                            labelText: question.questionText ?? '',
                          ),
                        )
                      : question.type == QuestionType.dropdown
                          ? FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: question.questionText ?? '',
                                    errorText:
                                        state.hasError ? state.errorText : null,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: state.value,
                                      onChanged: (String? newValue) {
                                        state.didChange(newValue);
                                      },
                                      items: question.options!
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            )
                          : question.type == QuestionType.checkbox
                              ? FormField<List<String>>(
                                  initialValue: [],
                                  builder:
                                      (FormFieldState<List<String>> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: question.questionText,
                                        errorText: state.hasError
                                            ? state.errorText
                                            : null,
                                      ),
                                      child: Column(
                                        children: question.options!
                                            .map((option) => CheckboxListTile(
                                                  title: Text(option),
                                                  value: state.value
                                                      ?.contains(option),
                                                  onChanged: (value) {
                                                    if (value != null) {
                                                      state.value?.add(option);
                                                    } else {
                                                      state.value
                                                          ?.remove(option);
                                                    }
                                                    state
                                                        .didChange(state.value);
                                                  },
                                                ))
                                            .toList(),
                                      ),
                                    );
                                  },
                                )
                              : question.type == QuestionType.sectionDescription
                                  ? Column(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(question.questionText)),
                                        Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                                question.options?.first ?? "")),
                                      ],
                                    )
                                  : Container(),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_upward),
                        onPressed: () {
                          formBuilderProvider.moveQuestionUp(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: () {
                          formBuilderProvider.moveQuestionDown(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          formBuilderProvider.editQuestion(context, index);
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
