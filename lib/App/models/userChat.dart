import 'package:intl/intl.dart';

class UserChat {
  final String id;
  final List<String>? members;
  final String lastMessage;

  UserChat({required this.id, required this.members, required this.lastMessage});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "lastMessage": lastMessage,
      "members": members,
    };
  }

  static UserChat fromJson(json) => UserChat(
        id: json['id'] as String? ?? "",
        lastMessage: json['lastMessage'] as String? ?? "",
        members: (json['members'] as List).map((item) => item as String).toList(),
      );

//   factory UserChat.fromJson(Map<String, dynamic> parsedJson) {
//     List<Data> dataList = [];
//     if (parsedJson['code'] != 1000 ||
//         parsedJson['message']
//             .toString()
//             .contains('No step count found for the range supplied')) {
//       DateTime now = new DateTime.now();
//       var formatter = new DateFormat('yyyy-MM-dd');
//       String formattedDateNow = formatter.format(now);
//       dataList.add(Data(day: formattedDateNow, steps: 0));
//     } else{
//       var list = parsedJson['message'] as List;
//       print(list.runtimeType);
//       dataList = list.map((i) => Data.fromJson(i)).toList();
//     }

//     return UserChat(code: parsedJson['code'], message: dataList);
//   }
// }

// class Data {
//   final String day;
//   final int steps;

//   Data({required this.day, required this.steps});

//   factory Data.fromJson(Map<String, dynamic> parsedJson) {
//     return Data(day: parsedJson['day'], steps: parsedJson['steps']);
//   }
}
