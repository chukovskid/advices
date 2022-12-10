class EventModel {
  final String? id;
  final String title;
  final String channelName;
  final String description;
  final DateTime startDate;
  final bool open;

  EventModel(
      {this.id,
      required this.title,
      required this.channelName,
      required this.description,
      required this.startDate,
      required this.open});

  factory EventModel.fromMap(Map data) {
    return EventModel(
      title: data['title'],
      channelName: data['channelName'],
      description: data['description'],
      startDate: data['startDate'],
      open: data['open'],
    );
  }

  factory EventModel.fromDS(String id, Map<String, dynamic> data) {
    return EventModel(
      id: id,
      title: data['title'],
      channelName: data['channelName'],
      description: data['description'],
      startDate: data['startDate'].toDate(),
      open: data['open'],
    );
  }

  static EventModel fromJson(json) => EventModel(
        id: json['id'] as String? ?? "",
        title: json['title'] as String? ?? "",
        channelName: json['channelName'] as String? ?? "",
        startDate: json['startDate'].toDate(),
        description: json['description'] as String? ?? "",
        open: json['open'] as bool? ?? false,
      );

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "channelName": channelName,
      "description": description,
      "startDate": startDate,
      "id": id,
      "open": open,
    };
  }
}
