// 카테고리 데이터를 관리하기 위한 모델 클래스입니다.
class Category {
  String name; // 카테고리명
  int value; // 기본값
  int order; // 순서

  // 카테고리 객체를 생성합니다.
  Category({
    required this.name,
    required this.order,
    this.value = 0,
  });

  // 객체를 JSON 맵으로 변환합니다.
  Map<String, dynamic> toJson() => {
    'name': name,
    'value': value,
    'order': order,
  };

  // JSON 맵에서 객체를 생성합니다.
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      value: (json['value'] as num?)?.toInt() ?? 0,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }
}