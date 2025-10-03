import 'dart:ui';
import 'package:counting_app/data/model/category.dart';
import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/main/utils/color_and_style_utils.dart';
import 'package:counting_app/main/views/counting/basic_counting_setting_view.dart';
import 'package:counting_app/main/widgets/custom_app_next_bar.dart';
import 'package:counting_app/main/widgets/glass_icon_button.dart';
import 'package:counting_app/main/viewmodels/basic_counting_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// 기본 카운팅 목록을 표시하고 관리하는 화면 위젯입니다.
class BasicCountingView extends StatelessWidget {
  // 기본 카운팅 뷰의 라우트 이름을 정의합니다.
  static const String routeName = '/basic_counting';

  const BasicCountingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BasicCountingViewModel(),
      child: Consumer<BasicCountingViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: CustomAppNextBar(
              title: AppLocalizations.of(context)!.newCounting,
              isNextEnabled: viewModel.categories.isNotEmpty,
              onNextPressed: () {
                if (viewModel.categories.isNotEmpty) {
                  _navigateToSettings(context, viewModel.categories);
                }
              },
            ),
            // CustomScrollView와 SliverReorderableList를 사용하여 스크롤 및 재정렬 가능한 목록을 구현합니다.
            body: CustomScrollView(
              slivers: [
                // 카테고리 목록을 표시하는 SliverReorderableList입니다.
                SliverReorderableList(
                  itemCount: viewModel.categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryItem(context, viewModel.categories[index], index, viewModel);
                  },
                  proxyDecorator: (Widget child, int index, Animation<double> animation) {
                    return Material(
                      type: MaterialType.transparency,
                      child: child,
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    viewModel.reorderCategories(oldIndex, newIndex);
                  },
                ),

                // 카테고리 추가 입력 필드를 조건부로 표시합니다.
                if (viewModel.isAddingCategory) SliverToBoxAdapter(child: _buildInputCard(context, viewModel)),

                // "카테고리 추가" 버튼을 표시합니다.
                SliverToBoxAdapter(child: _buildAddCategoryButton(context, viewModel)),
              ],
            ),
          );
        },
      ),
    );
  }

  // 설정 화면으로 이동하고 결과를 처리합니다.
  void _navigateToSettings(BuildContext context, List<Category> categories) async {
    // 이 함수는 설정 화면으로 이동하고, 반환된 설정 값으로 상태를 업데이트합니다.
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BasicCountingSettingView(categories: categories),
      ),
    );

    if (result != null && result is Map<String, int>) {
      // 결과에 따라 초기값을 업데이트하고 카테고리 값도 동기화합니다.
      Provider.of<BasicCountingViewModel>(context, listen: false).updateInitialValue(result['initialValue']!);
    }
  }

  // 카테고리 입력을 위한 카드 위젯을 생성합니다.
  Widget _buildInputCard(BuildContext context, BasicCountingViewModel viewModel) {
    // 이 위젯은 새 카테고리 이름을 입력받는 UI를 구성합니다.
    return SizedBox(
      height: 76.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1.0),
                ),
                margin: EdgeInsets.zero,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: viewModel.nameController,
                      autofocus: true,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20),
                      ],
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.listName,
                        counterText: '', // 글자 수 카운터 숨기기
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) => viewModel.addNewCategory(value),
                      style: const TextStyle(
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
              onPressed: viewModel.toggleAddCategoryView,
              icon: Icons.remove,
              iconColor: iconRedColor,
            ),
          ],
        ),
      ),
    );
  }

  // "카테고리 추가" 버튼 위젯을 생성합니다.
  Widget _buildAddCategoryButton(BuildContext context, BasicCountingViewModel viewModel) {
    // 이 위젯은 카테고리 추가 입력 필드를 표시하는 버튼을 구성합니다.
    final isEnabled = !viewModel.isAddingCategory;
    return SizedBox(
      height: 76.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: isEnabled ? Theme.of(context).colorScheme.outline : Colors.grey,
              width: 1.0,
            ),
          ),
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: isEnabled ? viewModel.toggleAddCategoryView : null,
            borderRadius: BorderRadius.circular(30.0),
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
  Widget _buildCategoryItem(BuildContext context, Category category, int index, BasicCountingViewModel viewModel) {
    // 이 위젯은 목록의 각 카테고리 항목을 구성하며, 삭제 및 재정렬 기능을 포함합니다.
    // ReorderableList의 아이템은 고유한 Key를 가져야 합니다.
    return SizedBox(
      key: ValueKey(category),
      height: 76.0,
      child: Dismissible(
        key: ObjectKey(category),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          viewModel.removeCategory(category);
        },
        background: Container(
          // 스와이프하여 삭제할 때 나타나는 배경 UI입니다.
          color: errorColor,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withAlpha(77),
                        borderRadius: BorderRadius.circular(30.0),
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
                                style: const TextStyle(
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