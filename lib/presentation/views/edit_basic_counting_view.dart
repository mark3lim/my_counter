
import 'dart:ui';

import 'package:counting_app/data/model/category.dart';
import 'package:counting_app/data/model/category_list.dart';
import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/presentation/utils/color_and_style_utils.dart';
import 'package:counting_app/presentation/views/edit_basic_counting_setting_view.dart';
import 'package:counting_app/presentation/widgets/custom_app_next_bar.dart';
import 'package:counting_app/presentation/widgets/glass_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditBasicCountingView extends StatefulWidget {
  static const String routeName = '/edit_basic_counting';

  final CategoryList categoryList;

  const EditBasicCountingView({super.key, required this.categoryList});

  @override
  State<EditBasicCountingView> createState() => _EditBasicCountingViewState();
}

class _EditBasicCountingViewState extends State<EditBasicCountingView> {
  static const _inputCardMargin = EdgeInsets.fromLTRB(16, 12, 16, 12);
  static const _categoryItemCardMargin = EdgeInsets.symmetric(horizontal: 14, vertical: 12);
  static const double _kItemHeight = 76.0;
  static const _cardBoarderRadius = 30.0;
  static const _edgeInsetsHorizontal = 20.0;

  late List<Category> _categories;
  final TextEditingController _nameController = TextEditingController();
  bool _isAddingCategory = false;

  @override
  void initState() {
    super.initState();
    _categories = List.from(widget.categoryList.categoryList);
  }

  void _toggleAddCategoryView() {
    setState(() {
      _isAddingCategory = !_isAddingCategory;
      if (!_isAddingCategory) {
        _nameController.clear();
      }
    });
  }

  void _addNewCategory() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    if (_categories.any((category) => category.name == name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.listExists),
        ),
      );
    } else {
      setState(() {
        _categories.add(Category(
          name: name,
          value: 0, // Default value for new category
          order: _categories.length,
        ));
        _isAddingCategory = false;
        _nameController.clear();
      });
    }
  }

  void _navigateToSettings() {
    Navigator.of(context).push<CategoryList>(
      MaterialPageRoute(
        builder: (context) => EditBasicCountingSettingView(
          originalCategoryList: widget.categoryList,
          categories: _categories,
        ),
      ),
    ).then((updatedCategoryList) {
      if (updatedCategoryList != null && mounted) {
        Navigator.of(context).pop(updatedCategoryList);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppNextBar(
        title: AppLocalizations.of(context)!.editCounting,
        isNextEnabled: _categories.isNotEmpty,
        onNextPressed: () {
          if (_categories.isNotEmpty) {
            _navigateToSettings();
          }
        },
      ),
      body: CustomScrollView(
        slivers: [
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

                for (int i = 0; i < _categories.length; i++) {
                  _categories[i].order = i;
                }
              });
            },
          ),
          if (_isAddingCategory) SliverToBoxAdapter(child: _buildInputCard()),
          SliverToBoxAdapter(child: _buildAddCategoryButton()),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
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
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _addNewCategory(),
                      textInputAction: TextInputAction.done,
                      style: TextStyle(
                          fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
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

  Widget _buildAddCategoryButton() {
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

  Widget _buildCategoryItem(Category category, int index) {
    return SizedBox(
      key: ValueKey(category),
      height: _kItemHeight,
      child: Dismissible(
        key: ObjectKey(category),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          setState(() {
            _categories.remove(category);
          });
        },
        background: Container(
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
