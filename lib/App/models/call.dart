class Call {
  String channelName;



  Call({
    this.channelName = "",

  });

  Map<String, dynamic> toMap() {
    return {
      'channelName': channelName,

    };
  }

  static Call fromJson(json) => Call(
        channelName: json['channelName'] as String? ?? "",
      );

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['channelName'] = channelName as String;

    return m;
  }

    Map<String, dynamic> toJson() => {
    'channelName': channelName,
  };

    @override
  String toString() {
    // channelName == null ? "x" : channelName;
    return '{ "channelName": "$channelName"}';
  }
}
