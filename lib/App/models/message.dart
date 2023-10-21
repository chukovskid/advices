class Message {
  final String? id;
  final String chatId;
  final String message;
  final String displayName;
  final String photoURL;
  final String senderId;
  final DateTime createdAt;
  final bool open;
  final int price;
  final bool payed;

  Message({
      this.id,
      required this.chatId,
      required this.message,
      required this.senderId,
      required this.displayName,
      required this.photoURL,
      required this.createdAt,
      required this.open,
      required this.price,
      required this.payed,
  });

  factory Message.fromMap(Map data) {
    return Message(
      message: data['message'],
      senderId: data['senderId'],
      chatId: data['chatId'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      createdAt: data['createdAt'],
      open: data['open'],
      price: data['price'],
      payed: data['payed'],
    );
  }

  factory Message.fromDS(String id, Map<String, dynamic> data) {
    return Message(
      id: id,
      chatId: data['chatId'],
      message: data['message'],
      senderId: data['senderId'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      createdAt: data['createdAt'].toDate(),
      open: data['open'],
      price: data['price'],
      payed: data['payed'],
    );
  }

  static Message fromJson(json) => Message(
        id: json['id'] as String? ?? "",
        chatId: json['chatId'] as String? ?? "",
        message: json['message'] as String? ?? "",
        senderId: json['senderId'] as String? ?? "",
        displayName: json['displayName'] as String? ?? "",
        createdAt: json['createdAt'].toDate(),
        photoURL: json['photoURL'] as String? ?? "",
        open: json['open'] as bool? ?? false,
        price: json['price'] as int? ?? 0,
        payed: json['payed'] as bool? ?? false,
      );

  Map<String, dynamic> toMap() {
    return {
      "chatId": chatId,
      "message": message,
      "senderId": senderId,
      "displayName": displayName,
      "photoURL": photoURL,
      "createdAt": createdAt,
      "id": id,
      "open": open,
      "price": price,
      "payed": payed,
    };
  }
}
