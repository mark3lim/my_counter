import 'package:counting_app/data/model/category_list.dart';
import 'package:counting_app/data/repositories/counting_repository.dart';
import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/main/utils/color_and_style_utils.dart';
import 'package:counting_app/main/views/basic_counting_view.dart';
import 'package:counting_app/main/views/home/calendar_home_page.dart';
import 'package:counting_app/main/views/saved_basic_counting_detail_view.dart';
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
        builder: (context) => SavedBasicCountingDetailView(categoryList: categoryList),
      ),
    );
    // 상세 화면에서 돌아오면 목록을 다시 불러와 최신 상태를 반영합니다.
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
                      Navigator.pushNamed(context, BasicCountingView.routeName),
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
                      return Dismissible(
                        key: Key(categoryList.id),
                        direction: DismissDirection.endToStart,
                        // 삭제 확인 다이얼로그를 표시합니다.
                        confirmDismiss: (direction) async {
                          final bool? confirmed = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(localizations.checkDeleteTitle),
                                content: Text(
                                    "'${categoryList.name} ${localizations.checkDeleteMessage}'"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(localizations.cancel),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                  TextButton(
                                    child: Text(localizations.delete),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                  ),
                                ],
                              );
                            },
                          );
                          return confirmed;
                        },
                        // 다이얼로그에서 '삭제'를 선택한 경우에만 호출됩니다.
                        onDismissed: (direction) async {
                          final index = _categoryLists.indexOf(categoryList);
                          final item = _categoryLists[index];
                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          final loc = AppLocalizations.of(context)!;

                          setState(() {
                            _categoryLists.removeAt(index);
                          });

                          try {
                            await _repository.deleteCategoryList(item.id);
                          } catch (e) {
                            setState(() {
                              _categoryLists.insert(index, item);
                            });

                            if (mounted) {
                              scaffoldMessenger.showSnackBar(
                                SnackBar(
                                  content: Text(loc.deleteFailedMessage),
                                  action: SnackBarAction(
                                    label: loc.okayBtn,
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        background: Container(
                          color: errorColor,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerRight,
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
                        child: CountingListItem(
                          categoryList: categoryList,
                          onTap: () => _navigateToDetail(categoryList),
                        ),
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
