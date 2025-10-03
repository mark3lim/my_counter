import 'package:counting_app/data/model/category_list.dart';
import 'package:counting_app/data/repositories/counting_repository.dart';
import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/main/utils/color_and_style_utils.dart';
import 'package:counting_app/main/views/counting/edit_basic_counting_view.dart';
import 'package:counting_app/main/views/home/calendar_home_page.dart';
import 'package:counting_app/main/widgets/bottom_nav_bar.dart';
import 'package:counting_app/main/widgets/counting_card.dart';
import 'package:counting_app/main/widgets/counting_list_item.dart';
import 'package:flutter/material.dart';

// 홈 화면을 표시하는 상태를 가진 위젯입니다.
class HomeView extends StatefulWidget {
  // 홈 뷰의 라우트 이름을 정의합니다.
  static const String routeName = '/home';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final CountingRepository _repository;
  List<CategoryList> _categoryLists = [];
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    // 위젯이 초기화될 때 저장된 카테고리 목록을 불러옵니다.
    super.initState();
    _repository = CountingRepository();
    _loadCategoryLists();
    _pageController.addListener(() {
      if (_pageController.page?.round() != _currentPage) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 저장소에서 카테고리 목록을 비동기적으로 불러와 상태를 업데이트합니다.
  // 카테고리 목록을 불러옵니다.
  Future<void> _loadCategoryLists() async {
    try {
      final fetched = await _repository.getAllCategoryLists();
      // isHidden이 true가 아닌 항목만 필터링하고, 최근 수정된 순서로 정렬
      final lists = fetched.where((list) => list.isHidden == false).toList()
        ..sort((a, b) => b.modifyDate.compareTo(a.modifyDate));
      if (!mounted) return;
      setState(() {
        _categoryLists = lists;
      });
    } catch (e) {
      if (!mounted) return;
      // 에러 처리: 스낵바나 다이얼로그로 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.dataLoadingErrorMessage)),
      );
    }
  }

  // 상세 화면으로 이동하고, 돌아왔을 때 목록을 새로고침하는 함수입니다.
  void _navigateToDetail(CategoryList categoryList) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CombinedCountingView(categoryList: categoryList),
      ),
    );
    _loadCategoryLists();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // 화면의 기본 구조를 설정합니다.
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        titleTextStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : onBackgroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 20.0),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          _buildHomeContent(context, localizations),
          const CalendarHomePage(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentPage: _currentPage),
    );
  }

  Widget _buildHomeContent(BuildContext context, AppLocalizations localizations) {
    return _categoryLists.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                CountingCard(
                  text: localizations.addNewCounting,
                  textAlign: TextAlign.left,
                  onTap: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CombinedCountingView(),
                        ),
                      ),
                  icon: Icons.mode_edit,
                ),
              ],
            ),
          )
        : CustomScrollView(
            slivers: [
              // 저장된 카테고리 목록을 동적으로 표시합니다.
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final categoryList = _categoryLists[index];
                      return CountingListItem(
                        categoryList: categoryList,
                        onTap: () => _navigateToDetail(categoryList),
                      );
                    },
                    childCount: _categoryLists.length,
                  ),
                ),
              ),
            ],
          );
  }
}
