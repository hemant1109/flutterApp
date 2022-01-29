/// status : 200
/// count : 2
/// data : [{"image":"https://cdn.airport-data.com/images/aircraft/thumbnails/000/950/950990.jpg","link":"https://www.airport-data.com/aircraft/photo/000950990.html","photographer":"Chris Hall"},{"image":"https://cdn.airport-data.com/images/aircraft/thumbnails/000/942/942481.jpg","link":"https://www.airport-data.com/aircraft/photo/000942481.html","photographer":"keithnewsome"}]

class ItemDetails {
  ItemDetails({
      required int status,
      required int count,
      required List<Data> data,}){
    _status = status;
    _count = count;
    _data = data;
}

  ItemDetails.fromJson(dynamic json) {
    _status = json['status'];
    _count = json['count'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  int _status=-1;
  int _count=-1;
  List<Data>? _data;

  int get status => _status;
  int get count => _count;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['count'] = _count;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// image : "https://cdn.airport-data.com/images/aircraft/thumbnails/000/950/950990.jpg"
/// link : "https://www.airport-data.com/aircraft/photo/000950990.html"
/// photographer : "Chris Hall"

class Data {
  Data({
      required String image,
      required String link,
      required String photographer,}){
    _image = image;
    _link = link;
    _photographer = photographer;
}

  Data.fromJson(dynamic json) {
    _image = json['image'];
    _link = json['link'];
    _photographer = json['photographer'];
  }
  String _image="";
  String _link="";
  String _photographer="";

  String get image => _image;
  String get link => _link;
  String get photographer => _photographer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    map['link'] = _link;
    map['photographer'] = _photographer;
    return map;
  }

}