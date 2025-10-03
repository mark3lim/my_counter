import 'package:flutter/material.dart';
import 'package:counting_app/data/model/category.dart';

class BasicCountingViewModel extends ChangeNotifier {
  final List<Category> _categories = [];
  final TextEditingController nameController = TextEditingController();
  bool _isAddingCategory = false;
  int _initialValue = 0;

  List<Category> get categories => _categories;
  bool get isAddingCategory => _isAddingCategory;
  int get initialValue => _initialValue;

  void toggleAddCategoryView() {
    _isAddingCategory = !_isAddingCategory;
    if (!_isAddingCategory) {
      nameController.clear();
    }
    notifyListeners();
  }

  void addNewCategory(String name) {
    if (name.isEmpty || _categories.any((category) => category.name == name)) {
      return;
    }
    _categories.add(Category(
      name: name,
      value: _initialValue,
      order: _categories.length,
    ));
    _isAddingCategory = false;
    nameController.clear();
    notifyListeners();
  }

  void reorderCategories(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final category = _categories.removeAt(oldIndex);
    _categories.insert(newIndex, category);
    notifyListeners();
  }

  void removeCategory(Category category) {
    _categories.remove(category);
    notifyListeners();
  }

  void updateInitialValue(int value) {
    _initialValue = value;
    for (final category in _categories) {
      category.value = value;
    }
    notifyListeners();
  }
}