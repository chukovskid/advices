class Question {
  final QuestionType type;
  late final String questionText;
  late final List<String>? options;
  final Map<String, int>? skipLogic;

  Question(
      {required this.type,
      required this.questionText,
      this.options,
      this.skipLogic});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      type: json['type'],
      questionText: json['questionText'],
      options:
          json['options'] != null ? List<String>.from(json['options']) : null,
      skipLogic: json['skipLogic'] != null
          ? Map<String, int>.from(json['skipLogic'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'questionText': questionText,
      'options': options,
      'skipLogic': skipLogic,
    };
  }
}

enum QuestionType { text, checkbox, dropdown, sectionDescription }
