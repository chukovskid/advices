class Service {
  String id;
  String name;
  String areaName;
  String imageUrl;
  int area;
  


  Service({
    this.id = "",
    this.name = "",
    this.area = 0,
    this.areaName = "",
    this.imageUrl = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'areaName': areaName,
      'imageUrl': imageUrl,
    };
  }

  static Service fromJson(json) => Service(
        area: int.tryParse(json['area'].toString()) as int ? ?? 0,
        id: json['id'] as String? ?? "",
        name: json['name'] as String? ?? "",
        areaName: json['areaName'] as String? ?? "",
        imageUrl: json['imageUrl'] as String? ?? "",
      );

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['id'] = id as String;
    m['name'] = name as String;
    m['area'] = area as int;
    m['areaName'] = areaName as String;
    m['imageUrl'] = imageUrl as String;

    return m;
  }

    Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'area': area,
    'areaName': areaName,
    'imageUrl': imageUrl,
  };

    @override
  String toString() {
    // id == null ? "x" : id;
    return '{ "name": "$name", "area": $area, "id": "$id", "areaName": "$areaName",  "imageUrl": "$imageUrl"}';
  }
}
