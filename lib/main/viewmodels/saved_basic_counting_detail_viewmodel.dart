import 'package:flutter/material.dart';
import 'package:counting_app/data/model/category_list.dart';
import 'package:counting_app/data/repositories/counting_repository.dart';

class SavedBasicCountingDetailViewModel extends ChangeNotifier {
  final CountingRepository _repository = CountingRepository();
  late CategoryList _currentCategoryList;
  bool _isUpdating = false;

  CategoryList get currentCategoryList => _currentCategoryList;
  bool get isUpdating => _isUpdating;

  void initialize(CategoryList categoryList) {
    _currentCategoryList = categoryList;
  }

  void updateCurrentCategoryList(CategoryList categoryList) {
    _currentCategoryList = categoryList;
    notifyListeners();
  }

  Future<void> updateCategoryValue(int index, int change) async {
    if (_isUpdating) return;
    _isUpdating = true;
    notifyListeners();

    final category = _currentCategoryList.categoryList[index];
    final oldValue = category.value;
    final newValue = oldValue + change;

    if (!_currentCategoryList.useNegativeNum && newValue < 0) {
      _isUpdating = false;
      notifyListeners();
      return;
    }

    category.value = newValue;
    _currentCategoryList.modifyDate = DateTime.now();
    notifyListeners();

    try {
      await _repository.updateCategoryList(_currentCategoryList);
    } catch (e) {
      category.value = oldValue;
      notifyListeners();
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }
}