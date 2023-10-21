import 'package:advices/App/models/services/question.dart';

class Contract {
  final int id;
  final String name;
  final List<Question> questions;

  Contract({required this.id, required this.name, required this.questions});

  Contract.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    name = json['name'],
    questions = (json['questions'] as List).map((e) => Question.fromJson(e)).toList();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'questions': questions.map((e) => e.toMap()).toList(),
    };
  }
}
