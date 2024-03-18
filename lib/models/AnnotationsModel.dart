

class AnnotationsModel {
  AnnotationsModel({
      String? AnnotationType,
      num? latitude,
      num? longitude,
      String? video_link,
      String? pdf_link

  }){
    _AnnotationType = AnnotationType;
    _latitude = latitude;
    _longitude = longitude;
    _video_link = video_link;
    _pdf_link = pdf_link;
}

  AnnotationsModel.fromJson(dynamic json) {
    _AnnotationType = json['AnnotationType'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _video_link = json['video_link'];
    _pdf_link = json['pdf_link'];
  }
  String? _AnnotationType;
  num? _latitude;
  num? _longitude;
  String? _video_link;
  String? _pdf_link;
AnnotationsModel copyWith({
  String? AnnotationType,
  num? latitude,
  num? longitude,
  String? video_link,
  String? pdf_link
}) => AnnotationsModel(
  AnnotationType: AnnotationType ?? _AnnotationType,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  video_link: video_link ?? _video_link,
  pdf_link: pdf_link ?? _pdf_link
);
  String? get name => _AnnotationType;
  num? get latitude => _latitude;
  num? get longitude => _longitude;
  String? get video_link => _video_link;
  String? get pdf_link => _pdf_link;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AnnotationType'] = _AnnotationType;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['video_link'] = _video_link;
    map['pdf_link'] = _pdf_link;
    return map;
  }
}