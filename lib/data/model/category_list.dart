import 'package:collection/collection.dart';
import 'package:counting_app/data/model/category.dart';
import 'package:uuid/uuid.dart';

class CategoryList {
  final String id; //고유 ID
  String name; //이름
  List<Category> categoryList; //카테고리
  DateTime modifyDate; // 생성, 수정 일자
  bool useNegativeNum; // 음수 사용 여부
  bool isHidden; // 숨김 여부
  bool isForAnalyze; // for analyze
  String cycleType; // daily, weekly, monthly

  CategoryList({
    String? id,
    required this.name,
    required this.categoryList,
    required this.modifyDate,
    required this.cycleType,
    this.useNegativeNum = false, // 음수 사용 여부
    this.isHidden = false, // 숨김 여부
    this.isForAnalyze = true, // for analyze
  }) : id = id ?? const Uuid().v4();

// JSON 맵에서 객체를 생성합니다.
factory CategoryList.fromJson(Map<String, dynamic> json) {
  var categoriesFromJson = json['categoryList'] as List<dynamic>? ?? [];
  List<Category> categoryList = categoriesFromJson
      .map((i) => Category.fromJson(i as Map<String, dynamic>))
      .toList();

  return CategoryList(
    id: json['id'] as String?,
    name: json['name'] as String? ?? '',
    categoryList: categoryList,
    modifyDate: json['modifyDate'] != null
        ? DateTime.parse(json['modifyDate'] as String)
        : DateTime.now(),
    useNegativeNum: json['useNegativeNum'] as bool? ?? false,
    isHidden: json['isHidden'] as bool? ?? false,
    isForAnalyze: json['isForAnalyze'] as bool? ?? true,
    cycleType: (() {
      final dynamic ct = json['cycleType'] ?? json['categoryType'];
      if (ct is String) {
        final v = ct.trim().toLowerCase();
        switch (v) {
          case 'general':
          case 'daily':
          case 'weekly':
          case 'monthly':
            return v;
          default:
            return '';
        }
      }
      return '';
    })(),
  );
}

  // 객체를 JSON 맵으로 변환합니다.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryList': categoryList.map((c) => c.toJson()).toList(),
      'modifyDate': modifyDate.toIso8601String(),
      'useNegativeNum': useNegativeNum,
      'isHidden': isHidden,
      'isForAnalyze': isForAnalyze,
      'cycleType': cycleType,
    };
  }

  // 카테고리 이름 리스트가 동일한지 확인합니다.
  bool isCategoryNameSame(List<String> nameList) {
    return const ListEquality().equals(categoryList.map((c) => c.name).toList(), nameList);
  }
}
