
import 'package:advices/utilities/constants.dart';

class EventModel{
  final String? id;
  final String title;
  final String description;
  final DateTime startDate;

  EventModel({this.id,required this.title, required this.description, required this.startDate});

  factory EventModel.fromMap(Map data) {
    return EventModel(
      title: data['title'],
      description: data['description'],
      startDate: data['startDate'],
    );
  }

  factory EventModel.fromDS(String id, Map<String,dynamic> data) {
    return EventModel(
      id: id,
      title: data['title'],
      description: data['description'],
      startDate: data['startDate'].toDate(),
    );
  }

    static EventModel fromJson(json) => EventModel(
        id: json['id'] as String? ?? "",
        title: json['title'] as String? ?? "",
        startDate: json['startDate'].toDate(),
        description: json['description'] as String? ?? "",
      );


  Map<String,dynamic> toMap() {
    return {
      "title":title,
      "description": description,
      "startDate":startDate,
      "id":id,
    };
  }
}