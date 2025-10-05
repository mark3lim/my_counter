import 'dart:convert';
import 'package:counting_app/core/error/data_number_limit_error.dart';
import 'package:counting_app/core/error/id_exist_error.dart';
import 'package:counting_app/data/model/category_list.dart';
import 'package:counting_app/data/repositories/system_info_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

// 카운팅 관련 데이터를 관리하는 저장소 클래스입니다.
class CountingRepository {
  static const String _storageKey = 'counting_lists';
  final Lock _lock = Lock();
  final SystemInfoRepository _systemInfo = SystemInfoRepository();

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
            } catch (e) {
              // JSON 파싱 오류 무시 또는 로깅
              continue;
            }
          }
        }
        return results;
      } catch (e) {
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

      // 저장된 카테고리 개수가 100개를 초과하는지 확인합니다.
      if (lists.length >= 100) {
        throw DataNumberLimitError("Maximum of 100 categories can be saved.");
      }

      if (lists.any((list) => list.id == newList.id)) {
        throw IdExistError("Category with ID ${newList.id} already exists.");
      }

      // 카테고리 개수를 업데이트합니다.
      final currentCount = await _systemInfo.getCategoryCount();
      await _systemInfo.updateCategoryCount(currentCount + 1);

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
      final initialLength = lists.length;
      lists.removeWhere((list) => list.id == id);

      // 실제로 항목이 삭제되었을 때만 카운트를 감소시킵니다.
      if (lists.length < initialLength) {
        final currentCount = await _systemInfo.getCategoryCount();
        await _systemInfo.updateCategoryCount(currentCount - 1);
      }

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
