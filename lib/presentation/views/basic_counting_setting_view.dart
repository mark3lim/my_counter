import 'dart:ui';

import 'package:counting_app/data/model/category.dart';
import 'package:counting_app/data/model/category_list.dart';
import 'package:counting_app/data/repositories/counting_repository.dart';
import 'package:counting_app/generated/l10n/app_localizations.dart';
import 'package:counting_app/presentation/utils/color_and_style_utils.dart';
import 'package:counting_app/presentation/widgets/custom_app_save_bar.dart';
import 'package:counting_app/presentation/views/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 기본 카운팅에 대한 세부 설정을 하는 화면 위젯입니다.
class BasicCountingSettingView extends StatefulWidget {
  // 기본 카운팅 설정 뷰의 라우트 이름을 정의합니다.
  static const String routeName = '/basic_counting_setting';

  final List<Category> categories;

  const BasicCountingSettingView({super.key, required this.categories});

  @override
  State<BasicCountingSettingView> createState() => _BasicCountingSettingViewState();
}

class _BasicCountingSettingViewState extends State<BasicCountingSettingView> {
  late TextEditingController _nameController;
  late final CountingRepository _repository;
  bool _allowNegative = false;
  bool _isHidden = false;
  bool _isSaving = false;
  bool _isNameEmpty = true;
  bool _didChangeDependencies = false;
  bool _isForAnalyze = false;
  String _selectedCycleValue = 'general';
  late List<Map<String, String>> _cycleData;

  // common text style
  final TextStyle commonTextStyle = const TextStyle(
    fontSize: 18, 
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    // 위젯의 상태를 초기화합니다.
    super.initState();
    _nameController = TextEditingController();
    // 초기 상태를 컨트롤러의 현재 값과 동기화
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
    // 컨트롤러 리소스를 해제하여 메모리 누수를 방지합니다.
    _nameController.dispose();
    super.dispose();
  }

  // 저장 버튼을 눌렀을 때 호출되는 함수입니다.
  void _onSave() async {
    if (_isSaving) return; // 재진입 방지

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus(); // 키보드 내리기

    setState(() {
      _isSaving = true;
    });

    try {
      final isNameExists = await _repository.isNameExists(name);
      if (isNameExists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.listExists)),
          );
        }
        return;
      }

      final newCategoryList = CategoryList(
        name: name,
        categoryList: List.unmodifiable(widget.categories),
        modifyDate: DateTime.now(),
        useNegativeNum: _allowNegative,
        isHidden: _isHidden,
        cycleType: _selectedCycleValue,
        isForAnalyze: _isForAnalyze,
      );

      await _repository.addCategoryList(newCategoryList);

      if (mounted) {
        // 저장 후 화면 스택을 모두 지우고 홈 화면으로 이동합니다.
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
    // 화면의 기본 UI 구조를 빌드합니다.
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

  // 이름 입력을 위한 텍스트 필드 위젯을 생성합니다.
  Widget _buildNameTextField({
    required TextEditingController controller,
    required String label,
    String hintText = '',
    double topRadius = 20.0,
    double bottomRadius = 20.0,
  }) {
    // 유리 효과가 적용된 컨테이너 안에 텍스트 필드를 배치합니다.
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
                    border: InputBorder.none, // TextField 테두리 제거
                  ),
                  textAlign: TextAlign.end, // 커서 및 텍스트 오른쪽 정렬
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

  // 토글 스위치가 포함된 설정 필드 위젯을 생성합니다.
  Widget _buildToggleField({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    double topRadius = 20.0,
    double bottomRadius = 20.0,
  }) {
    // 유리 효과가 적용된 컨테이너 안에 토글 스위치를 배치합니다.
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
