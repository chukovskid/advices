import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String? id;
  final String title;
  final String channelName;
  final String description;
  final DateTime startDate;
  final bool urgent;
  final DateTime dateCreated;

  final bool open;

  EventModel(
      {this.id,
      required this.title,
      required this.channelName,
      required this.description,
      required this.startDate,
      required this.dateCreated,
      required this.open,
      required this.urgent});

  factory EventModel.fromMap(Map data) {
    return EventModel(
      title: data['title'],
      channelName: data['channelName'],
      description: data['description'],
      startDate: data['startDate'],
      dateCreated: data['dateCreated'],
      open: data['open'],
      urgent: data['urgent'],
    );
  }

  factory EventModel.fromDS(String id, Map<String, dynamic> data) {
    Map<String, dynamic> detailsData = data['details'] ?? {};
    return EventModel(
      id: id,
      title: detailsData['title'] ?? "",
      channelName: detailsData['channelName'] ?? "",
      description: detailsData['description'] ?? "",
      startDate: (detailsData['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dateCreated: (detailsData['dateCreated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      open: detailsData['open'] ?? false,
      urgent: detailsData['urgent'] ?? false,
    );
  }


  static EventModel fromJson(json, detailsJson) => EventModel(
        id: json['id'] as String? ?? "",
        title: detailsJson['title'] as String? ?? "",
        channelName: json['channelName'] as String? ?? "",
        startDate: json['startDate'].toDate(),
        dateCreated: json['dateCreated'].toDate() as DateTime? ?? DateTime.now(),
        description: detailsJson['description'] as String? ?? "",
        open: detailsJson['open'] as bool? ?? false,
        urgent: detailsJson['urgent'] as bool? ?? false,
      );

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "channelName": channelName,
      "description": description,
      "startDate": startDate,
      // "dateCreated": dateCreated,
      "id": id,
      "open": open,
      "urgent": urgent,
    };
  }
}
