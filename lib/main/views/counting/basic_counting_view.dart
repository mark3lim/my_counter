import 'dart:ui';

import 'package:counting_app/data/model/category.dart';
import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/main/utils/color_and_style_utils.dart';
import 'package:counting_app/main/views/basic_counting_setting_view.dart';
import 'package:counting_app/main/widgets/custom_app_next_bar.dart';
import 'package:counting_app/main/widgets/glass_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 기본 카운팅 목록을 표시하고 관리하는 화면 위젯입니다.
class BasicCountingView extends StatefulWidget {
  // 기본 카운팅 뷰의 라우트 이름을 정의합니다.
  static const String routeName = '/basic_counting';

  const BasicCountingView({super.key});

  @override
  State<BasicCountingView> createState() => _BasicCountingViewState();
}

class _BasicCountingViewState extends State<BasicCountingView> {
  // UI 레이아웃에 사용될 상수들을 정의합니다.
  static const _inputCardMargin = EdgeInsets.fromLTRB(16, 12, 16, 12);
  static const _categoryItemCardMargin = EdgeInsets.symmetric(horizontal: 14, vertical: 12);
  static const double _kItemHeight = 76.0;
  static const _cardBoarderRadius = 30.0;
  static const _edgeInsetsHorizontal = 20.0;

  // 상태 변수들을 정의합니다.
  final List<Category> _categories = []; // 카테고리 목록을 저장합니다.
  final TextEditingController _nameController = TextEditingController(); // 새 카테고리 이름 입력을 위한 컨트롤러입니다.
  bool _isAddingCategory = false; // 카테고리 추가 UI의 표시 여부를 제어합니다.

  // 설정 값을 관리합니다.
  int _initialValue = 0; // 카운팅 초기값입니다.

  // 카테고리 추가 입력 UI의 표시 상태를 토글합니다.
  void _toggleAddCategoryView() {
    // 이 함수는 카테고리 추가 입력 필드의 가시성을 제어합니다.
    setState(() {
      _isAddingCategory = !_isAddingCategory;
      if (!_isAddingCategory) {
        _nameController.clear();
      }
    });
  }

  // 새 카테고리를 목록에 추가합니다.
  void _addNewCategory() {
    // 이 함수는 사용자가 입력한 이름으로 새 카테고리를 생성하고 목록에 추가합니다.
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    // 동일한 이름의 카테고리가 이미 있는지 확인합니다.
    if (_categories.any((category) => category.name == name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.listExists),
        ),
      );
    } else {
      setState(() {
        // 새 카테고리를 목록의 맨 아래에 추가하고 순서를 할당합니다.
        _categories.add(Category(
          name: name,
          value: _initialValue,
          order: _categories.length,
        ));
        _isAddingCategory = false;
        _nameController.clear();
      });
    }
  }

  // 설정 화면으로 이동하고 결과를 처리합니다.
  void _navigateToSettings() async {
    // 이 함수는 설정 화면으로 이동하고, 반환된 설정 값으로 상태를 업데이트합니다.
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BasicCountingSettingView(categories: _categories),
      ),
    );

    if (result != null && result is Map<String, int>) {
      setState(() {
        _initialValue = result['initialValue']!;
        // 기존 카테고리 값도 동기화
        for (final c in _categories) {
          c.value = _initialValue;
        }
      });
    }
  }

  @override
  void dispose() {
    // 위젯이 제거될 때 컨트롤러 리소스를 해제하여 메모리 누수를 방지합니다.
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 화면의 기본 UI 구조를 빌드합니다.
    return Scaffold(
      appBar: CustomAppNextBar(
        title: AppLocalizations.of(context)!.newCounting,
        isNextEnabled: _categories.isNotEmpty,
        onNextPressed: () {
          if (_categories.isNotEmpty) {
            _navigateToSettings();
          }
        },
      ),
      // CustomScrollView와 SliverReorderableList를 사용하여 스크롤 및 재정렬 가능한 목록을 구현합니다.
      body: CustomScrollView(
        slivers: [
          // 카테고리 목록을 표시하는 SliverReorderableList입니다.
          SliverReorderableList(
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(_categories[index], index);
            },
            proxyDecorator: (Widget child, int index, Animation<double> animation) {
              return Material(
                type: MaterialType.transparency,
                child: child,
              );
            },
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final Category item = _categories.removeAt(oldIndex);
                _categories.insert(newIndex, item);

                // 순서가 변경되었으므로 모든 카테고리의 order 값을 업데이트합니다.
                for (int i = 0; i < _categories.length; i++) {
                  _categories[i].order = i;
                }
              });
            },
          ),

          // 카테고리 추가 입력 필드를 조건부로 표시합니다.
          if (_isAddingCategory) SliverToBoxAdapter(child: _buildInputCard()),

          // "카테고리 추가" 버튼을 표시합니다.
          SliverToBoxAdapter(child: _buildAddCategoryButton()),
        ],
      ),
    );
  }

  // 카테고리 입력을 위한 카드 위젯을 생성합니다.
  Widget _buildInputCard() {
    // 이 위젯은 새 카테고리 이름을 입력받는 UI를 구성합니다.
    return SizedBox(
      height: _kItemHeight,
      child: Padding(
        padding: _inputCardMargin,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_cardBoarderRadius),
                  side: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1.0),
                ),
                margin: EdgeInsets.zero,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _edgeInsetsHorizontal),
                    child: TextField(
                      controller: _nameController,
                      autofocus: true,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20),
                      ],
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.listName,
                        counterText: '', // 글자 수 카운터 숨기기
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _addNewCategory(),
                      style: TextStyle(
                          fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 입력 필드를 닫는 취소 버튼입니다.
            GlassIconButton(
              onPressed: _toggleAddCategoryView,
              icon: Icons.remove,
              iconColor: iconRedColor,
            ),
          ],
        ),
      ),
    );
  }

  // "카테고리 추가" 버튼 위젯을 생성합니다.
  Widget _buildAddCategoryButton() {
    // 이 위젯은 카테고리 추가 입력 필드를 표시하는 버튼을 구성합니다.
    final isEnabled = !_isAddingCategory;
    return SizedBox(
      height: _kItemHeight,
      child: Padding(
        padding: _inputCardMargin,
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_cardBoarderRadius),
            side: BorderSide(
              color: isEnabled ? Theme.of(context).colorScheme.outline : Colors.grey,
              width: 1.0,
            ),
          ),
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: isEnabled ? _toggleAddCategoryView : null,
            borderRadius: BorderRadius.circular(_cardBoarderRadius),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.addList,
                    style: TextStyle(
                        color: isEnabled ? Theme.of(context).textTheme.bodyLarge?.color : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.add,
                    color: isEnabled ? iconGreenColor : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 각 카테고리 항목을 위한 위젯을 생성합니다.
  Widget _buildCategoryItem(Category category, int index) {
    // 이 위젯은 목록의 각 카테고리 항목을 구성하며, 삭제 및 재정렬 기능을 포함합니다.
    // ReorderableList의 아이템은 고유한 Key를 가져야 합니다.
    return SizedBox(
      key: ValueKey(category),
      height: _kItemHeight,
      child: Dismissible(
        key: ObjectKey(category),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          setState(() {
            // 인덱스 대신 category 객체를 사용하여 안전하게 제거합니다.
            _categories.remove(category);
          });
        },
        background: Container(
          // 스와이프하여 삭제할 때 나타나는 배경 UI입니다.
          color: errorColor,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: _edgeInsetsHorizontal),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.delete,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ],
          ),
        ),
        child: Padding(
          padding: _categoryItemCardMargin,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_cardBoarderRadius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withAlpha(77),
                        borderRadius: BorderRadius.circular(_cardBoarderRadius),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                            ),
                            ReorderableDragStartListener(
                              index: index,
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(8, 3, 8, 8),
                                child: Icon(Icons.drag_handle),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}