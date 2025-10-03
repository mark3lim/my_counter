
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

  void _navigateToDetail(CategoryList categoryList) async {
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
                        return CountingListItem(
                          categoryList: categoryList,
                          onTap: () => _navigateToDetail(categoryList),
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
