
import 'dart:ui';

import 'package:counting_app/data/model/category.dart';
import 'package:counting_app/data/model/category_list.dart';
import 'package:counting_app/data/repositories/counting_repository.dart';
import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/main/utils/color_and_style_utils.dart';
import 'package:counting_app/main/views/home/home_view.dart';
import 'package:counting_app/main/widgets/custom_app_save_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditBasicCountingSettingView extends StatefulWidget {
  final CategoryList originalCategoryList;
  final List<Category> categories;

  const EditBasicCountingSettingView({
    super.key,
    required this.originalCategoryList,
    required this.categories,
  });

  @override
  State<EditBasicCountingSettingView> createState() => _EditBasicCountingSettingViewState();
}

class _EditBasicCountingSettingViewState extends State<EditBasicCountingSettingView> {
  late TextEditingController _nameController;
  late final CountingRepository _repository;
  late bool _allowNegative;
  late bool _isHidden;
  late String _selectedCycleValue;
  late bool _isForAnalyze;
  bool _isSaving = false;
  bool _isNameEmpty = true;
  bool _didChangeDependencies = false;
  late List<Map<String, String>> _cycleData;

  final TextStyle commonTextStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.originalCategoryList.name);
    _allowNegative = widget.originalCategoryList.useNegativeNum;
    _isHidden = widget.originalCategoryList.isHidden;
    _selectedCycleValue = widget.originalCategoryList.cycleType;
    _isForAnalyze = widget.originalCategoryList.isForAnalyze;
    _isNameEmpty = _nameController.text.trim().isEmpty;
    _nameController.addListener(() {
      final isEmpty = _nameController.text.trim().isEmpty;
      if (_isNameEmpty != isEmpty && mounted) {
        setState(() {
          _isNameEmpty = isEmpty;
        });
      }
    });
    _repository = CountingRepository();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didChangeDependencies) {
      _cycleData = [
        {'value': 'general', 'label': AppLocalizations.of(context)!.general},
        {'value': 'daily', 'label': AppLocalizations.of(context)!.daily},
        {'value': 'weekly', 'label': AppLocalizations.of(context)!.weekly},
        {'value': 'monthly', 'label': AppLocalizations.of(context)!.monthly},
      ];
      _didChangeDependencies = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSave() async {
    if (_isSaving) return;

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isSaving = true;
    });

    try {
      final isNameExists = await _repository.isNameExists(name, excludeId: widget.originalCategoryList.id);
      if (isNameExists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.listExists)),
          );
        }
        return;
      }

      final updatedCategoryList = widget.originalCategoryList.copyWith(
        name: name,
        categoryList: List.unmodifiable(widget.categories),
        modifyDate: DateTime.now(),
        useNegativeNum: _allowNegative,
        isHidden: _isHidden,
        cycleType: _selectedCycleValue,
        isForAnalyze: _isForAnalyze,
      );

      await _repository.updateCategoryList(updatedCategoryList);

      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(HomeView.routeName, (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.saveFailedMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showCyclePicker() {
    final selectedIndex = _cycleData.indexWhere((element) => element['value'] == _selectedCycleValue);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: CupertinoPicker(
            itemExtent: 32.0,
            scrollController: FixedExtentScrollController(initialItem: selectedIndex),
            onSelectedItemChanged: (int index) {
              setState(() {
                _selectedCycleValue = _cycleData[index]['value']!;
              });
            },
            children: _cycleData.map((Map<String, String> cycle) {
              return Center(child: Text(cycle['label']!));
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppSaveBar(
        title: AppLocalizations.of(context)!.detailSetting,
        onSavePressed: _onSave,
        saveButtonTextColor: _isNameEmpty ? Colors.grey.shade400 : onBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNameTextField(
              controller: _nameController,
              label: AppLocalizations.of(context)!.nameInputTitle,
              hintText: AppLocalizations.of(context)!.nameInputHint,
              bottomRadius: 0.0,
            ),
            _buildCycleField(topRadius: 0.0),
            const SizedBox(height: 16),
            _buildToggleField(
              label: AppLocalizations.of(context)!.useNegativeNum,
              value: _allowNegative,
              onChanged: (value) {
                setState(() {
                  _allowNegative = value;
                });
              },
              bottomRadius: 0.0,
            ),
            _buildToggleField(
              label: AppLocalizations.of(context)!.hideToggle,
              value: _isHidden,
              onChanged: (value) {
                setState(() {
                  _isHidden = value;
                });
              },
              topRadius: 0.0,
            ),
            const SizedBox(height: 16.0),
            _buildToggleField(
              label: AppLocalizations.of(context)!.useAnalyzTitle,
              value: _isForAnalyze,
              onChanged: (value) {
                setState(() {
                  _isForAnalyze = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameTextField({
    required TextEditingController controller,
    required String label,
    String hintText = '',
    double topRadius = 20.0,
    double bottomRadius = 20.0,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius), bottom: Radius.circular(bottomRadius)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: glassmorphismColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius), bottom: Radius.circular(bottomRadius)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: commonTextStyle,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: onBackgroundColor),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none,
                  ),
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCycleField({
    double topRadius = 20.0,
    double bottomRadius = 20.0,
  }) {
    final selectedLabel = _cycleData.firstWhere((element) => element['value'] == _selectedCycleValue)['label']!;
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius), bottom: Radius.circular(bottomRadius)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: GestureDetector(
          onTap: _showCyclePicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: glassmorphismColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.countingType,
                  style: commonTextStyle,
                ),
                Text(
                  selectedLabel,
                  style: const TextStyle(color: onBackgroundColor, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleField({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    double topRadius = 20.0,
    double bottomRadius = 20.0,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius), bottom: Radius.circular(bottomRadius)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: glassmorphismColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius), bottom: Radius.circular(bottomRadius)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: commonTextStyle,
              ),
              const Spacer(),
              Switch(
                value: value,
                onChanged: onChanged,
                activeTrackColor: primaryColor,
                activeThumbColor: Colors.white,
                inactiveTrackColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
