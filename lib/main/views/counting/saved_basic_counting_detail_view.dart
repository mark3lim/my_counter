import 'package:counting_app/data/model/category_list.dart';
import 'package:counting_app/main/utils/color_and_style_utils.dart';
import 'package:flutter/material.dart';
import 'package:counting_app/main/viewmodels/saved_basic_counting_detail_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:counting_app/main/views/counting/edit_basic_counting_view.dart';

// 저장된 카운팅 목록의 상세 화면을 표시하는 위젯입니다.
class SavedBasicCountingDetailView extends StatelessWidget {
  final CategoryList categoryList;

  const SavedBasicCountingDetailView({super.key, required this.categoryList});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = SavedBasicCountingDetailViewModel();
        viewModel.initialize(categoryList);
        return viewModel;
      },
      child: Consumer<SavedBasicCountingDetailViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                viewModel.currentCategoryList.name,
                style: const TextStyle(
                  color: onBackgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                  ),
                ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CombinedCountingView(categoryList: viewModel.currentCategoryList),
                      ),
                    );
                    if (result != null && result is CategoryList) {
                      viewModel.updateCurrentCategoryList(result);
                    }
                  },
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: viewModel.currentCategoryList.categoryList.length,
              itemBuilder: (context, index) {
                final category = viewModel.currentCategoryList.categoryList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: cardBackgroundColor,
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
                                  color: dangerColor,
                                ),
                                onPressed: () => viewModel.updateCategoryValue(index, -1),
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
                                  color: successColor,
                                ),
                                onPressed: () => viewModel.updateCategoryValue(index, 1),
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
        },
      ),
    );
  }
}
