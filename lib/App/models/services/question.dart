class Question {
  final QuestionType type;
  late final String questionText;
  late final List<String>? options;

  Question({required this.type, required this.questionText, this.options});

  Question.fromJson(Map<String, dynamic> json) :
    type = json['type'],
    questionText = json['questionText'],
    options = json['options']?.cast<String>();

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'questionText': questionText,
      'options': options,
    };
  }
}


enum QuestionType { text, checkbox, dropdown, sectionDescription }
