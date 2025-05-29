class SlideModel {
  final String id;
  final String code;
  final num currentSlide;
  final List<String> slides;

  const SlideModel({
    this.id = '',
    this.code = '',
    this.currentSlide = 0,
    this.slides = const [],
  });

  SlideModel copyWith({
    String? id,
    String? code,
    num? currentSlide,
    List<String>? slides,
  }) {
    return SlideModel(
      id: id ?? this.id,
      code: code ?? this.code,
      currentSlide: currentSlide ?? this.currentSlide,
      slides: slides ?? this.slides,
    );
  }

  factory SlideModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return SlideModel();
    }

    return SlideModel(
      id: json['id'] is String ? json['id'] as String : '',
      code: json['code'] is String ? json['code'] as String : '',
      currentSlide:
          json['currentSlide'] is num ? json['currentSlide'] as num : 0,
      slides:
          (json['slides'] is List)
              ? List<String>.from(json['slides'].whereType<String>())
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'currentSlide': currentSlide,
      'slides': slides,
    };
  }
}
