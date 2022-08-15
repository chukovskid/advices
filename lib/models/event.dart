
import 'package:advices/utilities/constants.dart';

class EventModel{
  final String? id;
  final String title;
  final String description;
  final DateTime eventDate;

  EventModel({this.id,required this.title, required this.description, required this.eventDate});

  factory EventModel.fromMap(Map data) {
    return EventModel(
      title: data['title'],
      description: data['description'],
      eventDate: data['event_date'],
    );
  }

  factory EventModel.fromDS(String id, Map<String,dynamic> data) {
    return EventModel(
      id: id,
      title: data['title'],
      description: data['description'],
      eventDate: data['event_date'].toDate(),
    );
  }

    static EventModel fromJson(json) => EventModel(
        id: json['id'] as String? ?? "",
        title: json['title'] as String? ?? "",
        eventDate: json['event_date'].toDate(),
        description: json['description'] as String? ?? "",
      );


  Map<String,dynamic> toMap() {
    return {
      "title":title,
      "description": description,
      "event_date":eventDate,
      "id":id,
    };
  }
}