class EventModel {
  final String? id;
  final String title;
  final String channelName;
  final String description;
  final DateTime startDate;
  final bool urgent;
  // final DateTime dateCreated;

  final bool open;

  EventModel(
      {this.id,
      required this.title,
      required this.channelName,
      required this.description,
      required this.startDate,
      // required this.dateCreated,
      required this.open,
      required this.urgent});

  factory EventModel.fromMap(Map data) {
    return EventModel(
      title: data['title'],
      channelName: data['channelName'],
      description: data['description'],
      startDate: data['startDate'],
      // // dateCreated: data['dateCreated'],
      open: data['open'],
      urgent: data['urgent'],
    );
  }

  factory EventModel.fromDS(String id, Map<String, dynamic> data) {
    return EventModel(
      id: id,
      title: data['title'],
      channelName: data['channelName'],
      description: data['description'],
      startDate: data['startDate'].toDate(),
      // // dateCreated: data['dateCreated'].toDate() as DateTime? ?? DateTime.now(),
      open: data['open'],
      urgent: data['urgent'],
    );
  }

  static EventModel fromJson(json) => EventModel(
        id: json['id'] as String? ?? "",
        title: json['title'] as String? ?? "",
        channelName: json['channelName'] as String? ?? "",
        startDate: json['startDate'].toDate(),
        // // dateCreated: json['dateCreated'].toDate() as DateTime? ?? DateTime.now(),
        description: json['description'] as String? ?? "",
        open: json['open'] as bool? ?? false,
        urgent: json['urgent'] as bool? ?? false,
      );

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "channelName": channelName,
      "description": description,
      "startDate": startDate,
      // // "dateCreated": dateCreated,
      "id": id,
      "open": open,
      "urgent": urgent,
    };
  }
}
