import 'dart:convert';
import 'package:counting_app/data/model/category_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

// 카운팅 관련 데이터를 관리하는 저장소 클래스입니다.
class CountingRepository {
  static const String _storageKey = 'counting_lists';
  final Lock _lock = Lock();

  // 모든 카운팅 리스트를 불러옵니다.
  Future<List<CategoryList>> getAllCategoryLists() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        final decoded = json.decode(jsonString);
        if (decoded is! List) {
          return [];
        }
        final results = <CategoryList>[];
        for (final item in decoded) {
          if (item is Map<String, dynamic>) {
            try {
              results.add(CategoryList.fromJson(item));
            } catch (_) {
              // JSON 파싱 오류 무시 또는 로깅
              continue;
    }
          }
        }
        return results;
      } catch (_) {
        // 전체 JSON 디코딩 오류 무시 또는 로깅
        return [];
      }
    }
    return [];
  }

  // 모든 카운팅 리스트를 저장합니다.
  Future<void> saveAllCategoryLists(List<CategoryList> lists) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(lists.map((list) => list.toJson()).toList());
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      rethrow;
    }
  }

  // 새로운 카운팅 리스트를 추가합니다.
  Future<void> addCategoryList(CategoryList newList) async {
    await _lock.synchronized(() async {
      final lists = await getAllCategoryLists();
      if (lists.any((list) => list.id == newList.id)) {
        throw ArgumentError('이미 존재하는 ID입니다: ${newList.id}');
      }
      lists.add(newList);
      await saveAllCategoryLists(lists);
    });
  }

  // 기존 카운팅 리스트를 업데이트합니다.
  Future<bool> updateCategoryList(CategoryList updatedList) async {
    return await _lock.synchronized(() async {
      final lists = await getAllCategoryLists();
      final index = lists.indexWhere((list) => list.id == updatedList.id);
      if (index != -1) {
        lists[index] = updatedList;
        await saveAllCategoryLists(lists);
        return true;
      }
      return false;
    });
  }

  // ID를 사용하여 카운팅 리스트를 삭제합니다.
  Future<void> deleteCategoryList(String id) async {
    await _lock.synchronized(() async {
      final lists = await getAllCategoryLists();
      lists.removeWhere((list) => list.id == id);
      await saveAllCategoryLists(lists);
    });
  }

  Future<bool> isNameExists(String name, {String? excludeId}) async {
    final lists = await getAllCategoryLists();
    return lists.any((list) =>
        list.name.trim().toLowerCase() == name.trim().toLowerCase() &&
        (excludeId == null || list.id != excludeId));
  }
}
