import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoryTabs<T> extends StatelessWidget {
  final List<CategoryTab<T>> tabs;
  final T activeTab;
  final ValueChanged<T> onTabChanged;

  const CategoryTabs({
    super.key,
    required this.tabs,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children:
            tabs.map((tab) {
              final isActive = tab.id == activeTab;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => onTabChanged(tab.id),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isActive ? AppTheme.primaryColor : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tab.label,
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey[800],
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class CategoryTab<T> {
  final T id;
  final String label;

  CategoryTab({required this.id, required this.label});
}
