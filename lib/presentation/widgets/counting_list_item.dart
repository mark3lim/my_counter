
import 'package:counting_app/data/model/category_list.dart';
import 'package:counting_app/presentation/widgets/counting_card.dart';
import 'package:flutter/material.dart';

class CountingListItem extends StatelessWidget {
  final CategoryList categoryList;
  final VoidCallback onTap;

  const CountingListItem({
    super.key,
    required this.categoryList,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
      child: CountingCard(
        text: categoryList.name,
        textAlign: TextAlign.left,
        onTap: onTap,
        icon: _getIconForCycleType(categoryList.cycleType),
        backgroundColor: _getColorForCycleType(categoryList.cycleType),
      ),
    );
  }

  IconData _getIconForCycleType(String? cycleType) {
    switch (cycleType) {
      case 'general':
        return Icons.list_alt;
      case 'daily':
        return Icons.today;
      case 'weekly':
        return Icons.view_week;
      case 'monthly':
        return Icons.calendar_today;
      default:
        return Icons.list_alt;
    }
  }

  Color _getColorForCycleType(String? cycleType) {
    switch (cycleType) {
      case 'general':
        return const Color(0xFFD0E4FF);
      case 'daily':
      case 'weekly':
      case 'monthly':
        return const Color(0xFFBCC5E7);
      default:
        return const Color(0xFFC9CCD1);
    }
  }
}
