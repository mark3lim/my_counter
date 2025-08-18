import 'package:counting_app/data/model/category_list.dart';
import 'package:counting_app/data/repositories/counting_repository.dart';
import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/presentation/views/edit_basic_counting_view.dart';
import 'package:flutter/material.dart';

// 저장된 카운팅 목록의 상세 화면을 표시하는 위젯입니다.
class SavedBasicCountingDetailView extends StatefulWidget {
  final CategoryList categoryList;

  const SavedBasicCountingDetailView({super.key, required this.categoryList});

  @override
  State<SavedBasicCountingDetailView> createState() => _SavedBasicCountingDetailViewState();
}

class _SavedBasicCountingDetailViewState extends State<SavedBasicCountingDetailView> {
  late CategoryList _currentCategoryList;
  final CountingRepository _repository = CountingRepository();

  @override
  void initState() {
    super.initState();
    // 위젯의 초기 상태로 전달받은 카테고리 리스트를 설정합니다.
    _currentCategoryList = widget.categoryList;
  }

  // 카테고리 값을 변경하고 저장소에 업데이트하는 함수입니다.
  // Prevent concurrent updates
  bool _isUpdating = false;

  Future<void> _updateCategoryValue(int index, int change) async {
    if (_isUpdating) return;                        // 중복 호출 방지
    _isUpdating = true;
    
    final category = _currentCategoryList.categoryList[index];
    final oldValue = category.value;
    // ignore: unused_local_variable
    final oldModifyDate = _currentCategoryList.modifyDate;
    final newValue = oldValue + change;

    // 음수 허용 여부를 확인합니다.
    if (!_currentCategoryList.useNegativeNum && newValue < 0) {
      _isUpdating = false;
      return;                                       // 음수를 허용하지 않으면 0 미만으로 내려가지 않습니다.
    }

    setState(() {
      category.value = newValue;
      _currentCategoryList.modifyDate = DateTime.now();
    });

    try {
      await _repository.updateCategoryList(_currentCategoryList);
    } catch (e) {
      // 저장 실패 시 이전 값으로 롤백
      setState(() {
        category.value = oldValue;
      });
      // 저장 실패 시 사용자에게 알림
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.saveFailedMessage)),
        );
      }
    } finally {
      _isUpdating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentCategoryList.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditBasicCountingView(categoryList: _currentCategoryList),
                ),
              );
              if (result != null && result is CategoryList && mounted) {
                setState(() {
                  _currentCategoryList = result;
                });
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _currentCategoryList.categoryList.length,
        itemBuilder: (context, index) {
          final category = _currentCategoryList.categoryList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Color(0xFFEEEEEE),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 카테고리 이름
                  Expanded(
                    child: Text(
                      category.name,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      // 감소 버튼
                      SizedBox(
                        width: 60,
                        child: IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Color(0XFFDC3545),
                          ),
                          onPressed: () => _updateCategoryValue(index, -1),
                        ),
                      ),
                      // 현재 값
                      SizedBox(
                        width: 40,
                        child: Text(
                          '${category.value}',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // 증가 버튼
                      SizedBox(
                        width: 50,
                        child: IconButton(
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Color(0xFF198754),
                          ),
                          onPressed: () => _updateCategoryValue(index, 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
