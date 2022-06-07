class Law {
  String id;
  String name;
  int index;
  


  Law({
    this.id = "",
    this.name = "",
    this.index = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'index': index,
    };
  }

  static Law fromJson(json) => Law(
        index: int.tryParse(json['index'].toString()) as int ? ?? 0,
        id: json['id'] as String? ?? "",
        name: json['name'] as String? ?? "",
      );

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['id'] = id as String;
    m['name'] = name as String;

    return m;
  }

    Map<String, dynamic> toJson() => {
    'name': name,
    'index': index,
  };

    @override
  String toString() {
    // id == null ? "x" : id;
    return '{ "name": "$name", "index": $index, "id": "$id"}';
  }
}
