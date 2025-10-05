
import 'package:counting_app/data/model/category_list.dart';
import 'package:counting_app/data/repositories/counting_repository.dart';
import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/main/utils/color_and_style_utils.dart';
import 'package:counting_app/main/views/counting/saved_basic_counting_detail_view.dart';
import 'package:counting_app/main/widgets/counting_list_item.dart';
import 'package:flutter/material.dart';

class HiddenListsView extends StatefulWidget {
  static const String routeName = '/hidden_lists';

  const HiddenListsView({super.key});

  @override
  State<HiddenListsView> createState() => _HiddenListsViewState();
}

class _HiddenListsViewState extends State<HiddenListsView> {
  late final CountingRepository _repository;
  List<CategoryList> _hiddenLists = [];

  @override
  void initState() {
    super.initState();
    _repository = CountingRepository();
    _loadHiddenLists();
  }

  Future<void> _loadHiddenLists() async {
    try {
      final fetched = await _repository.getAllCategoryLists();
      final lists = fetched.where((list) => list.isHidden == true).toList()
        ..sort((a, b) => b.modifyDate.compareTo(a.modifyDate));
      if (!mounted) return;
      setState(() {
        _hiddenLists = lists;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.dataLoadingErrorMessage)),
      );
    }
  }

  Future<void> _navigateToDetail(CategoryList categoryList) async {
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SavedBasicCountingDetailView(categoryList: categoryList),
      ),
    );
    _loadHiddenLists();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.showHiddenLists,
          style: const TextStyle(
            color: onBackgroundColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            ),
          ),
      ),
      body: _hiddenLists.isEmpty
          ? Center(
              child: Text(localizations.noHiddenItems),
            )
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final categoryList = _hiddenLists[index];
                          return Dismissible(
                            key: ValueKey(categoryList.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              if (!mounted) return false;
                              
                              // BuildContext 관련 값들을 미리 캡처
                              final dialogContext = context;
                              final checkTitle = localizations.checkDeleteTitle;
                              final checkMessage = localizations.checkDeleteMessage;
                              final cancelText = localizations.cancel;
                              final deleteText = localizations.delete;
                              
                              return await showDialog<bool>(
                                context: dialogContext,
                                builder: (context) => AlertDialog(
                                  title: Text(checkTitle),
                                  content: Text(checkMessage),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: Text(cancelText),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: Text(deleteText),
                                    ),
                                  ],
                                ),
                              ) ?? false;
                            },
                            onDismissed: (direction) async {
                              // BuildContext 캡처
                              final scaffoldMessenger = ScaffoldMessenger.of(context);
                              final errorMessage = localizations.dataLoadingErrorMessage;
                              
                              // 원본 데이터 보관 (복원용)
                              final deletedItem = categoryList;
                              final deletedIndex = index;

                              setState(() {
                                _hiddenLists.removeAt(index);
                              });
                              
                              try {
                                await _repository.deleteCategoryList(categoryList.id);
                                if (!mounted) return;
                                
                              } catch (e) {
                                if (!mounted) return;
                                // 삭제 실패 시 항목 복원
                                setState(() {
                                  _hiddenLists.insert(deletedIndex, deletedItem);
                                });
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(content: Text(errorMessage)),
                                );
                              }
                            },
                            child: CountingListItem(
                              categoryList: categoryList,
                              onTap: () => _navigateToDetail(categoryList),
                            ),
                          );
                        },
                        childCount: _hiddenLists.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
